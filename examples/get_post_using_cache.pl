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

my $post = $api->post_get({ use_cache => 1, post_id => 1253116 });

printf "[Status] %s\n", $api->{status} || '';
printf "[Error] %s\n",  $api->{error}  || '';

printf "[Post result]\n%s\n", Dumper($post);
