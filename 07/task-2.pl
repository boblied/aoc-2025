#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 7 Part 2
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use List::Util qw/sum/;
use List::MoreUtils qw/indexes/;

$logger->info("START");

use constant { BEAM => '|', SPLITTER => '^', };

chomp(my $first = <>);
my @current = split(//, ($first =~ tr/S/|/r));

my @Count = (0) x @current;
$Count[$_] = 1 for (indexes { $_ eq BEAM } @current );

my $Total = 0;
while (<>)
{
    chomp;
    my @next = split //;

    $logger->debug("$.  current=[@current]");
    $logger->debug("$. splitter=[@next]");
    $Total += manifold(\@current, \@next, \@Count);
    $logger->debug("$.     next=[@next]");
    $logger->debug("$.    Count=[@Count]");
    @current = @next;
}

say sum @Count;

sub manifold($current, $next, $currentCount)
{
    my $splits = 0;
    my @beam = indexes { $_ eq BEAM } $current->@*;

    my @nextCount = $currentCount->@*;

    for my $b ( @beam )
    {
        if ( $next->[$b] eq SPLITTER )
        {
            $splits++;
            $next->[$b-1] = $next->[$b+1] = BEAM;

            $nextCount[$b-1] += $currentCount->[$b];
            $nextCount[$b+1] += $currentCount->[$b];
            $nextCount[$b] = 0; # Can't reach the splitter itself
        }
        else
        {
            $next->[$b] = BEAM;
        }
    }
    $currentCount->@* = @nextCount;
    return $splits;
}

$logger->info("FINISH");
