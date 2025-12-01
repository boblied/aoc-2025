#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 1 Part 2
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

    # $n can be > 100 (more than one rotation)
    my $full = int( $n / 100 );
    $code += $full;

    $n %= 100;
    $n = -$n if ( $d eq "L" );

    my $next = $place + $n;
    if ( $place != 0 )
    {
        $code++ if ( $next >= 100 || $next <= 0 );
    }

    $logger->debug("place=$place, n=$n, next=$next (", $next%100 , ") code=$code");
    $place = $next % 100;
}
say $code;

$logger->info("FINISH");
