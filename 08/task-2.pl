#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 8 Part 2  Playground
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;

my $CircuitCount = 3;
my $Limit = 1000;
AOC::setup({"circuit:i" => \$CircuitCount, "limit:i" => \$Limit });

use Feature::Compat::Class;
use Array::Heap::PriorityQueue::Numeric;

class Point {
    field $name :param :reader //= "0,0,0";
    field @p : reader;  # Store as array of three coordinates

    use constant { X => 0, Y => 1, Z => 2 };
    ADJUST {
        @p = split(",", $name);
    }

    # Coordinate accessors
    method x() { $p[X] }
    method y() { $p[Y] }
    method z() { $p[Z] }

    # String form to use as hash key or for logging
    method show() { "($name)" }
    use overload '""' => sub { $_[0]->show() };

    # Euclidean distance, not including the square root (stay in integers)
    method dist($other) {
        use List::Util qw/sum/;
        return sum map { $_ * $_ }
            map { ($other->p)[$_] - ($self->p)[$_] } X, Y, Z;
    }
}


$logger->info("START");

# Array of Point
my @Box;
{
    chomp(my @input = <>);  # Slurp entire input into an array
    @Box = map { Point->new(name=>$_) } @input;
}
$logger->info(scalar(@Box), " junction boxes");
$logger->info("first: ", $Box[0]->show, " last: ", $Box[-1]->show);

my $pq = Array::Heap::PriorityQueue::Numeric->new;

# Calculate distance between every pair of points, but only in
# one direction (distance is commutative).
for my $first ( 0 .. $#Box-1 )
{
    my $box1 = $Box[$first];
    for my $box2 ( @Box[ $first+1 .. $#Box ] )
    {
        my $d = $box1->dist($box2);
        $pq->add( [$box1,$box2],  $d );
        $logger->debug("\nBUILD: ", $box1->name," ",$box2->name," ",$d);
    }
}
$logger->info("inserted ", $pq->size(), " into priority queue");

my $Total = 0;

class CircuitList {
    field $logger :param;
    field @circuit;     # Array of hash references
    ADJUST{ @circuit = ( {} ) } # Never use element 0.

    method find($box)
    {
        for my ($where, $c) ( indexed @circuit )
        {
            return $where if exists $c->{$box};
        }
        return 0;
    }

    method add($box1, $box2)
    {
        my $where1; my $where2;
        $where1 = $self->find($box1);
        $where2 = $self->find($box2);

        if ( $where1 == 0 && $where2 == 0 )
        {
            # New pair, start a new circuit
            push @circuit, { $box1 => 1 , $box2 => 1 };
            $logger->debug("New, added $box1 $box2, count=", $#circuit);
        }
        elsif ( $where1 && $where2 && $where1 != $where2 )
        {
            # Points have been seen before, but they're in different
            # circuits. Add the second circuit into the first, and then
            # remove it from the circuit list.
            $circuit[$where1]{$_} = 1 for keys %{$circuit[$where2]};
            splice(@circuit, $where2, 1);
            $logger->debug("Merged, $box1 $box2, now in $where1");
        }
        elsif ( $where1 || $where2 )
        {
            # One of the points is in a circuit, add the other point
            my $where = ( $where1 != 0 ) ? $where1 : $where2;
            $circuit[$where]{$box1} = 1;
            $circuit[$where]{$box2} = 1;
            $logger->debug("Found, added $box1, $box2 to $where:\n", join(" | ", sort keys %{$circuit[$where]}));
        }
    }

    method multiply($howMany)
    {
        use List::Util qw/product/;
        my @n = sort { $b <=> $a } map { scalar(keys %$_) } @circuit;
        return List::Util::product @n[0..$howMany-1];
    }

    method size($where) { return scalar keys %{$circuit[$where]} }
}

my $Circuit = CircuitList->new(logger=>$logger);

my $count;
while ( $Limit-- > 0  &&  (my $pair = $pq->get()) )
{
    $count++;
    $Circuit->add($pair->[0]->name, $pair->[1]->name);

    if ( $Circuit->size(1) == @Box )
    {
        $logger->info("Last pair after $count: $pair->@*");
        $Total = $pair->[0]->x * $pair->[1]->x;
        last;
    }
}

say $Total;

$logger->info("FINISH");
