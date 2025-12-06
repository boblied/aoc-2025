#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 6 Part 2
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use List::Util qw/sum product max/;
use List::MoreUtils qw/slide pairwise/;

$logger->info("START");

my $Total = 0;

# Read in the entire array as a list of strings.
my @Array;
chomp(@Array = <>);

# Save the operators. The location of the operators is the
# beginning of each column
my @Op = split " ", (my $op = pop @Array);

my $Height = $#Array;
my $Width  = $#Op;
$logger->info("Array size is ", $Height+1, " x ", $Width+1);

# Calculate the field positions from the locations of the operators
my @Beg; my @Size;
{
    $op =~ s/[*+]/x/g;
    $op .= " x";    # Mark for end of last field
    for ( my $c = index($op, "x"); $c >= 0 ;  $c = index($op, "x", $c+1)  )
    {
        push @Beg, $c;
    }

    # Field width is the difference between start columns
    @Size = slide { $b-$a-1 } @Beg;
    pop @Beg; # Undo fake marker for last field
}

# Convert each row into a list of fixed-width fields.
for my ($i, $str) ( indexed @Array )
{
    $Array[$i] = [ pairwise { substr($str, $a, $b) } @Beg, @Size ];
}

sub add(@list) { sum @list };
sub multiply(@list) { product @list };
my %Calc = ( '+' => \&add, '*' => \&multiply );

$Total += doColumn($_, $Calc{$Op[$_]}, \@Array) for (0 .. $Width);
say $Total;

sub doColumn($col, $op, $array)
{
    my @column = getCol($array, $col);
    my $size = length($column[0]); # Fixed-width columns

    # Turn each string into a list of digits
    $column[$_] = [ split(//, $column[$_]) ] for (0 .. $#column);

    # Form number from vertical slices. Addition and multiplication
    # are commutative, so doesn't matter whether we start right or left,
    # despite what the story implies.
    my @num = map { trim(join "", getCol(\@column, $_)) } (0 .. $size-1);

    return $op->(@num);
}

# Extract a vertical slice from an array
sub getCol($array, $col)
{
    return map { $array->[$_][$col] } 0 .. $array->$#*
}

$logger->info("FINISH");
