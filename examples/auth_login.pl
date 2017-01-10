use utf8;
use strict;
use warnings;
use RP::API::Dirty;
use Data::Dumper;
use Carp;

# Do not public your password and any private info on the internet!
#
my $debug    = 0;
my $username = 'rp_api_dirty_tester';
my $password = 'qwer1234';

my $api = RP::API::Dirty->new( debug => $debug );

my $info = $api->method_info('auth_login');
print "[API request info]\n" . Dumper($info->{request}) . "\n";
#print "[API response info]\n" . Dumper($info->{response}) . "\n";

my $res = $api->auth_login({ username => $username, password => $password });
print "[API request result]\n" . Dumper($res);