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
my $username = 'rp_api_dirty_tester';
my $password = 'qwer1234';

GetOptions(
	'debug|d' => \$debug,
);

my $api = RP::API::Dirty->new(debug => $debug);

my $info = $api->method_info('get_post_votes');
print "[API request info]\n" . Dumper($info->{request}) . "\n";

my $res = $api->get_post_votes({ post_id => 1253116 });

printf "[Status] %s\n", $api->{status} || '';
printf "[Error] %s\n",  $api->{error}  || '';

printf "[Votes result]\n%s\n", Dumper($res);
