#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Archive::Zip qw(:ERROR_CODES :CONSTANTS);
use File::Copy qw/copy/;
use File::Path qw/rmtree/;

my $selenium_core_url = 'http://release.openqa.org/selenium-core/1.0.1/selenium-core-1.0.1.zip';
my $core_dir = fetch_and_extract($selenium_core_url);
my $core_iedoc = "$core_dir/core/iedoc.xml";
die "Can't find $core_iedoc" unless -e $core_iedoc;

rmtree 'target';
mkdir 'target';
my $iedoc_dest = 'target/iedoc.xml';
print "Copying $core_iedoc to $iedoc_dest...\n";
copy($core_iedoc => $iedoc_dest) or die "Can't copy $core_iedoc to ${iedoc_dest}: $!";
exit;


sub fetch_and_extract {
    my $url = shift;
    my $tmp_dir = "core-$$";
    mkdir $tmp_dir or die "Can't mkdir $tmp_dir: $!";
    chdir $tmp_dir or die "Can't chdir $tmp_dir: $!";
    (my $zip_file = $url) =~ s#.+/##;
    unless (-e $zip_file) {
            print "Fetching $url...\n";
            getstore($url, $zip_file);
            die "Couldn't fetch $url!" unless -e $zip_file;
    }

    print "Reading $zip_file...\n";
    my $zip = Archive::Zip->new;
    unless ($zip->read($zip_file) == AZ_OK) {
            die "Failed to read $zip_file";
    }

    my $src_dir = $tmp_dir;
    print "Extracting to $src_dir...\n";
    $zip->extractTree;
    chdir '..';
    return $src_dir;
}
