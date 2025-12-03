#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 3 Part 1
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

$logger->info("START");

my $total = 0;
while (<>)
{
    chomp;
    my @bank = split //;

    $total += joltage(\@bank);
}
say $total;

sub joltage($bank)
{
    use List::Util qw/max/;
    use List::MoreUtils qw/first_index/;

    my $last = pop @$bank;

    my $first = max @$bank;
    my $where = first_index { $_ == $first } @$bank;
    push @$bank, $last;

    my $second = max $bank->@[$where+1 .. $bank->$#*];

    return "$first$second";
}

$logger->info("FINISH");

