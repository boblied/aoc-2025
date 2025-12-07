#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 7 Part 1
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use List::MoreUtils qw/indexes/;

$logger->info("START");

use constant { BEAM => '|', SPLITTER => '^', };

chomp(my $first = <>);
my @current = split(//, ($first =~ tr/S/|/r));

my $Total = 0;
while (<>)
{
    chomp;
    my @next = split //;

    $logger->debug(" current=[@current]");
    $logger->debug("splitter=[@next]");
    $Total += manifold(\@current, \@next);
    $logger->debug("    next=[@next]");
    @current = @next;
}

say $Total;

sub manifold($current, $next)
{
    my $splits = 0;
    my @beam = indexes { $_ eq '|' } $current->@*;

    for my $b ( @beam )
    {
        if ( $next->[$b] eq '^' )
        {
            $splits++;
            $next->[$b-1] = $next->[$b+1] = '|';
        }
        else
        {
            $next->[$b] = '|';
        }
    }
    return $splits;
}

$logger->info("FINISH");
