#!/usr/bin/perl -w
use warnings;
use strict;
use inc::Module::Install 0.95;

# Need to explicitly pre-load this so it doesn't conflict with a mocked one
# created by loading Test::Mock::LWP
eval "require LWP::UserAgent";

name            'Test-WWW-Selenium';
license         'other';
all_from        'lib/Test/WWW/Selenium.pm';
author          'Luke Closs <test-www-selenium@awesnob.com>';
requires       'LWP::UserAgent'  => 0;
requires       'URI::Escape'     => '3.30';
build_requires 'Test::More'      => '0.42';
build_requires 'Test::Exception' => 0;
build_requires 'Test::Mock::LWP' => 0;
build_requires 'Test::Pod'       => 0;

# Auto-install all dependencies from CPAN
auto_install;

# Generate the Makefile
repository 'http://github.com/lukec/cpan-selenium-rc-perl';
WriteAll;
