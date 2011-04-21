#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use lib 'lib';

BEGIN {
    unless ($ENV{SRC_LIVE_TESTS}) {
        plan skip_all => 'not running live interweb tests';
	exit;
    }

    plan tests => 5;
    use_ok 'Test::WWW::Selenium';
}

# utf8 wide character in print warnings will dump to stdout if we don't change binmode
my $builder = Test::More->builder;
binmode $builder->output,         ':utf8';
binmode $builder->failure_output, ':utf8';
binmode $builder->todo_output,    ':utf8';

my $tws = Test::WWW::Selenium->new(browser_url => 'http://example.com');
isa_ok $tws, 'Test::WWW::Selenium';

$tws->open('/');
$tws->title_like(qr/Example domains/);
$tws->click_ok("//a[.='RFC 2606']");
$tws->wait_for_page_to_load;
# incase the above didn't work..
$tws->pause(2000);
my $location = $tws->get_location;
is $location, 'http://tools.ietf.org/html/rfc2606', 'get_location is aboslute';
