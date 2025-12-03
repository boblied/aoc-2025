#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 3 Part 2
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;

my $Need = 12;
AOC::setup( { "need:i" => \$Need } );

use List::Util qw/max/;
use List::MoreUtils qw/first_index/;

$logger->info("START");

my $total = 0;
while (<>)
{
    chomp;
    my @bank = split //;
    $total += joltage(\@bank, $Need);
}
say $total;

sub joltage($bank, $need)
{
    my $jolt ="";

    # Remove enough from the end so that we can satisfy $need
    my @tail = splice(@$bank, -($need-1) );

    for (  1 .. $need )
    {
        my $digit = max @$bank;
        $jolt .= $digit;

        my $where = first_index { $_ == $digit } @$bank;

        # $logger->debug("n=$_, bank=(@$bank) tail=(@tail) digit=$digit where=$where jolt=$jolt$digit");

        # No longer need front of list, make shorter
        splice(@$bank, 0, $where+1);

        # Restore one digit from tail for next digit
        push @$bank, shift @tail;
    }
    $logger->info("jolt=$jolt");
    return $jolt;
}

$logger->info("FINISH");
