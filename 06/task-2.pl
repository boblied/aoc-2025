#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2b.pl Advent of Code 2025 Day 6 Part 2 (Second solution)
#=============================================================================
# Try something simpler: just operate on indidvidual columns
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use List::Util qw/sum product/;
use Term::ANSIColor;

$logger->info("START");

sub add(@list) { sum @list };
sub multiply(@list) { product @list };
my %Calc = ( '+' => \&add, '*' => \&multiply );

my @Array;
while (<>)
{
    chomp;
    push @Array, [ split // ];
}

my $Func;
my $Total = 0;
my @NumberList;

for my $col ( reverse 0 .. $Array[0]->$#* )
{
    # Extract the column of digits
    my @digits = map { $Array[$_][$col] } 0 .. $#Array;

    my $operator = pop @digits;    # The operator or blank at the bottom

    my $n = trim(join "", @digits); # Form number, remove spaces

    if ( $n eq "" ) {   # Separator column
        @NumberList = ();
    } else {
        push @NumberList, $n;
    }

    $logger->debug("col=$col [@digits] -> $n NumberList=[@NumberList] $operator");

    if ( $operator =~ m/[*+]/ ) # Reached last column in group?
    {
        my $colResult = $Calc{$operator}->(@NumberList);
        $Total += $colResult;

        $logger->debug("COL $col ", colored(["red"], "colResult=$colResult"), " Total=$Total");
    }
}

say $Total;

$logger->info("FINISH");
