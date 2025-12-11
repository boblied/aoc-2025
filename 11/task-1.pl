#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 11 Part 1  Reactor
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

$logger->info("START");

my %Graph;
{
    while (<>) {
        chomp;
        my ($from, @to) = split /:? /;

        push @{$Graph{$from}}, @to;
    }
}
$logger->info("Graph has ", scalar(keys(%Graph)), " nodes");

say findPath(\%Graph, "you", "out");

sub findPath($graph, $start, $end)
{
    my %seen;
    my $pathCount = 0;

    my @stack = ( [ "", $start ] );

    while ( my $x = pop @stack )
    {
        my ($depth, $node) = $x->@*;
        for my $neighbor ( $graph->{$node}->@* )
        {
            $logger->debug("$depth $node");
            if ( $neighbor eq $end )
            {
                $pathCount++;
                $logger->debug("$depth Found $end, count=$pathCount");
            }
            else
            {
                push @stack, [ "--$depth", $neighbor ];
            }
        }
    }
    return $pathCount;
}

$logger->info("FINISH");
