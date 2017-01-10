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

my $info = $api->method_info('get_posts');
print "[API request info]\n" . Dumper($info->{request}) . "\n";
#print "[API response info]\n" . Dumper($info->{response}) . "\n";

my $posts = $api->get_posts({
	threshold_date   => 'day',
	sorting          => 'date_created',
	page             => 1,
	per_page         => 1,
	threshold_rating => 0,
});

print "[Posts result]\n" . Dumper($posts) . "\n";
