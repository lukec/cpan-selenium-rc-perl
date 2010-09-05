#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 5;
use Test::Mock::LWP;

BEGIN {
    use lib 'lib';
    use_ok 't::WWW::Selenium';  # subclass for testing
}

my $sel = t::WWW::Selenium->new;

$sel->set_timeout(50000); #msec

is $sel->ua->timeout(), 230, 'lwp timeout is affected';


