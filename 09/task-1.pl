#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 9  Part 1  Movie Theater
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use Feature::Compat::Class;

class Point {
    use List::Util qw/sum product/;

    field $name :param :reader //= "0,0,0";
    field @p : reader;  # Store as array of three coordinates

    use constant { X => 0, Y => 1 };
    ADJUST {
        @p = split(",", $name);
    }

    # Coordinate accessors
    method x() { $p[X] }
    method y() { $p[Y] }

    # String form to use as hash key or for logging
    method show() { "($name)" }
    use overload '""' => sub { $_[0]->show() };

    # Euclidean distance, not including the square root (stay in integers)
    method diagonal($other) {
        return sum map { $_ * $_ }
            map { ($other->p)[$_] - ($self->p)[$_] } 0 .. $#p;
    }

    # City distance
    method block($other) {
        # a
        return sum map { abs( ($other->p)[$_] - ($self->p)[$_] ) } 0 .. $#p;
    }

    method area($other) {
        return product map { abs( ($other->p)[$_] - ($self->p)[$_] ) + 1 } 0 .. $#p;
    }
}

$logger->info("START");

my @Plane;  # Array of Point
{
    chomp(my @input = <>);
    @Plane = map { Point->new(name => $_) } @input;
}
$logger->info(scalar(@Plane), " points");

my $Biggest = 0;
for my ($i, $first) ( indexed @Plane )
{
    for my $j ( $i+1 .. $#Plane )
    {
        my $second = $Plane[$j];
        my $area = $first->area($second);
        $Biggest = $area if $area > $Biggest;
        $logger->debug("$first to $second => $area");
    }
}
say $Biggest;

$logger->info("FINISH");
