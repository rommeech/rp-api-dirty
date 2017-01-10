use utf8;
use strict;
use warnings;
use RP::API::Dirty;
use Getopt::Long qw/:config no_ignore_case bundling/;
use Data::Dumper;
use Carp;

# Do not public your password and any private info on the internet!
#
my $debug    = 0;
my $info     = 0;
my $username = 'rp_api_dirty_tester';
my $password = 'qwer1234';
my $method   = 'vote_post';

GetOptions(
	'debug|d' => \$debug,
	'info|i'  => \$info,
);

my $api = RP::API::Dirty->new(debug => $debug);

# Auth
print "[Authentication]\n";
my $auth = $api->auth_login({ username => $username, password => $password });
croak(sprintf(
	'Cannot login with %s/%s***** / %s %s',
	$username,
	substr($password, 0, 3),
	$auth->{status},
	$auth->{error},
)) if $auth->{status} ne 'ok';
printf "Successfully, uid=%s, sid=%s\n", $auth->{uid}, $auth->{sid};

if ($info) {
	my $mres = $api->method_info($method);
	printf "[API method %s info]  %s\n", $method, Dumper($mres->{request});
	exit;
}

my $res = $api->$method({
	post_id => 1253116,
	vote    => 1,
	uid     => $auth->{uid},
	sid     => $auth->{sid},
});

printf "[API method %s call result]\n", $method;
if ($res->{status} ne 'ok') {
	printf "Fail: %s %s / %s\n", $res->{status}, $res->{error}, Dumper($res);
}
else {
	printf "Successfully: %s\n", Dumper($res);
}

