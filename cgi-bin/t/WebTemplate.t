#!/usr/bin/perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use Test::File;

use FindBin;
require File::Spec->catfile( $FindBin::Bin, 'Funcs.pl' );

BEGIN {
    use_ok('miRkwood::WebTemplate');
}
require_ok('miRkwood::WebTemplate');

ok( my $result1 = miRkwood::WebTemplate::get_link_back_to_results(1),
    'can call get_link_back_to_results()');
is( $result1, './resultsWithID.pl?run_id=1',
    'get_link_back_to_results returns expected value');

ok( my $result2 = miRkwood::WebTemplate::get_css_file(),
    'can call get_css_file()');

ok( my $result3 = miRkwood::WebTemplate::get_js_file(),
    'can call get_js_file()');

ok( $ENV{SERVER_NAME} = 'toto',
    'Can set SERVER_NAME variable');
ok( my $result6 = miRkwood::WebTemplate::get_cgi_url('ABCDE'),
    'can call make_url()');

