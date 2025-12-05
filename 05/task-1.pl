#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 5  Part 1
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use lib "$FindBin::Bin/lib";
use AOC::Range;

$logger->info("START");

my $Range = AOC::Range->new();
my $Fresh = 0;

while (<>)
{
    chomp;

    if    ( /^$/ ) { next }
    elsif ( /-/ )
    {
        $Range->add( split /-/ );
        $logger->debug($Range->show);
    }
    else
    {
        $Fresh++ if $Range->find($_);
        $logger->debug("Find $_: Fresh=$Fresh");
    }
}
say $Fresh;

$logger->info( "FINISH" );
