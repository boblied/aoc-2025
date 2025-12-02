#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 2 Part 1
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use List::Util qw/all/;

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
    $sum += invalidSum($pair->@*);
}
say $sum;

sub invalidSum($from, $to)
{
    my $sum = 0;

    for my $code ( $from .. $to )
    {
        $sum += invalid($code);
    }
    return $sum;
}

sub invalid($code)
{
    state @factor = (  [], [], [    1], [    1], [  1,2], [    1] ,  # 0 to 5
                      [1,2,3], [    1], [1,2,4], [  1,3], [1,2,5] ); # 6 to 10

    my $len = length($code);

    for my $f ( $factor[$len]->@* )
    {
        my @group = unpack("(A$f)*", $code);
        return $code if all { $_ eq $group[0] } @group;
    }
    return 0;
}

$logger->info("FINISH");
