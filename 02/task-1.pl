#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
#  
# task-1.pl Advent of Code 2025 Day 2 Part 1
#=============================================================================
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

$logger->info("START");

my @range;
while (<>)
{
    chomp;
    push @range, map { [ split("-", $_) ] } split ",";
}

my $sum = 0;
for my $pair ( @range )
{
    $sum += invalid($pair->@*);
}
say $sum;

sub invalid($from, $to)
{
    my $sum = 0;

    for my $code ( $from .. $to )
    {
        my $len = length($code);
        next if ( $len % 2) == 1;

        if ( substr($code, 0, $len/2) eq substr($code, $len/2) )
        {
            $sum += $code;
            $logger->debug("Found $code");
        }
    }
    return $sum;
}

$logger->info("FINISH");
