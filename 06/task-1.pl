#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 6 Part 1
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use List::Util qw/sum product/;

$logger->info("START");

my @Array;
my @Operation;
while (<>)
{
    chomp;
    if ( /[0-9]/ ) { push @Array, [ split ] }
    else { @Operation = split }
}

sub add(@num) { return sum @num }
sub multiply(@num) { return product @num }
my %Op = ( '+' => \&add, '*' => \&multiply );

my $Total = 0;
for my $column (0 .. $#Operation)
{
    my @column = map { $Array[$_][$column] } 0 .. $#Array;
    my $val = $Op{$Operation[$column]}->(@column);

    $Total += $val;
    $logger->debug("Column $column: op=$Operation[$column] val=$val Total=$Total");
}

say $Total;

$logger->info("FINISH");
