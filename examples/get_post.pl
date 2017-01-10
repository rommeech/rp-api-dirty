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

my $info = $api->method_info('get_post');
print "[API request info]\n" . Dumper($info->{request}) . "\n";
#print "[API response info]\n" . Dumper($info->{response}) . "\n";

my $post = $api->get_post({ post_id => 1253116 });

printf "[Status] %s\n", $api->{status} || '';
printf "[Error] %s\n",  $api->{error}  || '';

printf "[Post result]\n%s\n", Dumper($post);
