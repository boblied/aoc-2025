#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
#  
# task-1.pl Advent of Code 2025 Day 1 Part 1
#=============================================================================
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

$logger->info("START");

my $place = 50;

my $code = 0;

while (<>)
{
    my ($d, $n) = m/([LR])(\d+)/;
    $n = -$n if ( $d eq "L" );

    $place = ($place + $n) % 100;
    $code ++ if $place == 0;
}
say $code;

$logger->info("FINISH");

