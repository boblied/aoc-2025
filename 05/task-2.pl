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

while (<>)
{
    chomp;

    if( /-/ )
    {
        $Range->add( split /-/ );
    }
}
$logger->debug($Range->show);

say $Range->total();

$logger->info( "FINISH" );
