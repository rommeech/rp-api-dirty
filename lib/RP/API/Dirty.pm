package RP::API::Dirty;

=info
[Test account]
username: rp_api_dirty_tester
password: qwer1234
email: roman.parshin@hotmail.com
{"uid": "205848", "sid": "db52d0b2ff3cff2335556494fceba171"}
=cut

use utf8;
use strict;
use warnings;
use RP::API::Dirty::Schema;
use Encode qw/decode encode/;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common;
use Scalar::Util;
use Data::Dumper;
use URI::Escape;
use JSON::XS;
use Carp;

our $VERSION = 0.01;
our $AUTOLOAD;

sub new
{
	my $class = shift;
	return bless { @_ }, $class;
}

sub default_timeout    { 60 }
sub default_user_agent { __PACKAGE__ . ' HTTP Client, v' . $VERSION }

sub get_result      { $_[0]->{result} }
sub get_status      { $_[0]->{status} }
sub get_error       { $_[0]->{error} }
sub get_request     { $_[0]->{request} }
sub get_response    { $_[0]->{response} }
sub get_timeout     { $_[0]->{timeout} || default_timeout }
sub get_user_agent  { $_[0]->{user_agent} || default_user_agent }

sub set_timeout
{
	my ($self, $value) = @_;
	$self->{timeout} = $value if $value;
}

sub set_user_agent
{
	my ($self, $value) = @_;
	$self->{user_agent} = $value if $value;
}

sub get_http_client
{
	my $self = shift;

	if (!defined $self->{http_client}) {
		$self->{http_client} = LWP::UserAgent->new(
        	timeout  => $self->get_timeout,
        	agent    => $self->get_user_agent,
        	ssl_opts => { verify_hostname => 0 },
        )
	}

	return $self->{http_client};
}

sub set_http_client
{
	my ($self, $value) = @_;
	if ($value && ref $value eq 'LWP::UserAgent') {
		$self->{http_client} = $value;
	}
}

sub get_api_method_info
{
	my ($self, $api_method) = @_;
	return $self->_get_api_method_cfg($api_method);
}

sub AUTOLOAD
{
	my $self = shift;
	my $method = $AUTOLOAD;
	$method =~ s/.*:://;
	$self->call($method, @_);
}

sub call
{
	my ($self, $api_method, $data, $callback) = @_;

	croak qq/API method "$api_method" not exists!/
		unless RP::API::Dirty::Schema->can($api_method);

	$self->{result}   = '';
	$self->{status}   = '';
	$self->{error}    = '';
	$self->{request}  = '';
	$self->{response} = '';

	# Get action config
	#
	my $cfg = $self->_get_api_method_cfg($api_method);

	## Check mandaroty parameters
	##
	#foreach my $param (@{$cfg->{request}->{required}}) {
	#	if (!defined $data->{$param} &&
	#	    !$cfg->{request}->{properties}->{$param}->{default}
	#	) {
	#		return _return_error(sprintf(
	#			'Parameter %s is required, got no value, no default found',
	#			$param,
	#		));
	#	}
	#}

	# Build request data
	#
	my $url    = $data->{url}    || $cfg->{url};
	my $method = $data->{method} || $cfg->{method};
	
	my $param  = {};
	while (my ($key, $prop) = each %{ $cfg->{request}->{properties} })
	{
		if (defined $data->{$key})
		{
			# Check type
			if (defined $prop->{enum}) {
				if (!_in_array($data->{$key}, @{ $prop->{enum} })) {
					return _return_error(sprintf(
						'%s: invalid enum-value %s=%s (allowed: %s)',
						$api_method,
						$key,
						$data->{$key},
						join(', ',  @{ $prop->{enum} })
					));
				}
			}
			elsif (defined $prop->{type} && (
			    ($prop->{type} eq 'string' && !_is_string($data->{$key}))
			 || ($prop->{type} eq 'integer' && !_is_int($data->{$key}))
			)) {
				return _return_error(sprintf(
					'%s: invalid type %s value %s=%s',
					$api_method,
					$prop->{type},
					$key,
					$data->{$key},
				));
			}

			$param->{$key} = $data->{$key};
		}
		elsif (defined $prop->{default}) {
			$param->{$key} = $prop->{default};
		}
		elsif (defined $cfg->{request}->{mandatory}->{$key}) {
			return _return_error(sprintf(
				'%s: parameter %s is required',
				$api_method,
				$key,
			));
		}
	}

	# URL's placeholders
	#
	if (my @placeholders = ($url =~ m/\{(.*?)\}/g)) {
		foreach my $key (@placeholders) {
			if (!defined $data->{$key}) {
				return _return_error(sprintf(
					'%s: parameter %s is required',
					$api_method,
					$key,
				));
			}
			$url =~ s/\{$key\}/$data->{$key}/g;
		}
	}

	my $qs = join('&',
				map { sprintf('%s=%s', $_, uri_escape($param->{$_})) }
				keys %$param);

	# Build request
	#
	if ($method eq 'POST') {
		my $headers = HTTP::Headers->new(
			Content_Type   => 'application/x-www-form-urlencoded',
			Content_Length => length($qs),
		);
		$self->{request} = HTTP::Request->new(POST => $url, $headers, $qs);
	}

	elsif ($method eq 'DELETE' || $method eq 'PATCH') {
		$url .= (index($url, '?') ? '?' : '&') . $qs;
		$self->{request} = HTTP::Request->new($method => $url);
	}

	elsif (!$method || $method eq 'GET') {
		$url .= (index($url, '?') ? '?' : '&') . $qs;
		$self->{request} = HTTP::Request->new(GET => $url);
	}

	else {
		return _return_error(sprintf('Unsopported HTTP method=%s', $method));
	}

	# Set up custom HTTP headers
	#
	if ($cfg->{http_headers}) {
		foreach my $hdr (keys %{ $cfg->{http_headers} }) {
			if (!defined $data->{$hdr}) {
				return _return_error(sprintf(
					'Header %s is required, got no value of parameter %s',
					$cfg->{http_headers}->{$hdr},
					$hdr,
				));
			}
			$self->{request}->header(
				$cfg->{http_headers}->{$hdr},
				$data->{$hdr}
			);
		}
	}

	# Call API action request
	#
	$self->{response} = $self->get_http_client->request($self->{request});
	
	if ($self->{debug}) {
		print "Request:\n";
		print $self->{request}->as_string();
		print "Response:\n";
		print $self->{response}->as_string();
	}

	# Parse and check response
	#
	my $res = {};

	if ($self->{response}->content
	 && $self->{response}->content ne 'null'
	 && index(
	        $self->{response}->header('Content-Type'),
	        'application/json'
	    ) == 0
	) {
        $res = decode_json($self->{response}->content);
    }

    elsif ($self->{response}->code > 200) {
    	$res->{status} = 'http_error';
    	$res->{error}  = sprintf(
    		'%s %s',
    		$self->{response}->code,
    		$self->{response}->message,
    	);
    }

    else {
    	$res->{status} = 'server_error';
    	$res->{error}  = 'Invalid response format';
    }

    # Make human-readable error string
    #
    if (defined $res->{errors} && ref $res->{errors} eq 'ARRAY') {
    	$res->{error} = join(
    		"; ",
    		map { sprintf('%s: %s', $_->{name}, $_->{description}->{code}) }
    			@{ $res->{errors} }
    	);
    }
    elsif (defined $res->{errors}) {
    	$self->{error} = $res->{errors};
    }

    $res->{status} ||= 'ok';
    
    $self->{result} ||= $res;

    # Call callback (TBD, for async requests)
    #
    if ($callback && ref $callback eq 'CODE') {
    	$callback->($res, $self);
    }

	# Return
	#
	return $res;
}

=cut
sub auth_register           { shift->call('auth_register',          @_) }
sub auth_login              { shift->call('auth_login',             @_) }
sub auth_password_change    { shift->call('auth_password_change',   @_) }
sub auth_password_reset     { shift->call('auth_password_reset',    @_) }
sub auth_social_login       { shift->call('auth_social_login',      @_) }
sub auth_social_register    { shift->call('auth_social_register',   @_) }
sub auth_social_connect     { shift->call('auth_social_connect',    @_) }
sub auth_social_disconnect  { shift->call('auth_social_disconnect', @_) }

sub get_posts               { shift->call('get_posts',              @_) }
sub create_post             { shift->call('create_post',            @_) }
sub get_post                { shift->call('get_post',               @_) }
sub get_post_votes          { shift->call('get_post_votes',         @_) }
sub vote_post               { shift->call('vote_post',              @_) }

sub posts_subscriptions     { shift->call('posts_subscriptions',    @_) }
=cut



sub _in_array
{
	my ($value, @list) = @_;
	foreach my $item (@list) {
		return 1 if $item eq $value;
	}
	return 0;
}

sub _is_int { $_[0] eq int($_[0]) }
sub _is_string { 1 }

sub _get_api_method_cfg
{
	my ($self, $api_method) = @_;

	unless (defined $self->{cfg}->{$api_method})
	{
		croak "Schema for $api_method not exists!"
			unless RP::API::Dirty::Schema->can($api_method);
		
		my $cfg = RP::API::Dirty::Schema->$api_method();
		
		$cfg->{request}  = $cfg->{request_schema}
			? decode_json(encode('utf8', $cfg->{request_schema}))
			: {};
		#$cfg->{response} = $cfg->{response_schema}
		#	? decode_json(encode('utf8', $cfg->{response_schema}))
		#	: {};

		if (defined $cfg->{required} && ref $cfg->{required} eq 'ARRAY') {
			$cfg->{request}->{required} = $cfg->{required};
		}
		
		$cfg->{method}    ||= RP::API::Dirty::Schema::method;
		$cfg->{mime_type} ||= RP::API::Dirty::Schema::mime_type;

		$cfg->{request}->{mandatory} = { map { $_ => 1 }
		                                 @{ $cfg->{request}->{required} } };

		$self->{cfg}->{$api_method} = $cfg;
	}

	return $self->{cfg}->{$api_method};
}

sub _return_error
{
	my $error_msg    = shift;
	my $error_status = shift || 'error';
	carp $error_msg;
	return({
		status	=> $error_status,
		error	=> $error_msg,
	});
}

1;

__END__

