#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 12 Part 1  Christmas Tree Farm
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use Feature::Compat::Class;

class Present
{
    use Log::Log4perl qw/get_logger/;
    get_logger("AOC");

    use List::Util qw/sum/;

    field $id      :reader :param;
    field $name    :reader;

    field @shape;
    field $height :reader = 0;
    field $width  :reader = 0;
    field $cover  :reader = 0;

    ADJUST { $name = ( 'A' .. 'Z' )[$id] ; }
 
    method show() {
        join("\n", "$id: ($name)", map { "$_->@*" } @shape)
    }
    use overload '""' => sub { $_[0]->show() };

    method addToShape($row) {
        push @shape, [ split //, $row ];
        $height++;
        $width = $shape[0]->$#*;
        $cover += () = ($row =~ m/#/g);
    }

    method coverCount() {
        sum map { scalar grep /#/, $_->@* } @shape;
    }
}

class Region
{
    field $width  :reader :param;
    field $height :reader :param;
    field $q  :param(quantity);

    field @quantity :reader ;
    ADJUST { @quantity = @$q };

    method show() { "($width X $height) [@quantity]" }
    use overload '""' => sub { $_[0]->show() };

    method area() { return $width * $height }
}


$logger->info("START");

my @Present;
my $p;

my @Region;

while (<>)
{
    chomp;

    if    ( /^([0-9]+):/   )
    {
        $p = $1;
        $logger->info("Begin present $p");
        $Present[$1] = Present->new(id => $1);
    }
    elsif ( /[#.]+/      )
    {
        $Present[$p]->addToShape($_)
    }
    elsif ( /(\d+)x(\d+):/ )
    {
        my @f = split " ";
        shift @f;
        # push @Region, { wid => $1, ht => $2, quant => [ @f ] };
        push @Region, Region->new( width => $1, height => $2, quantity => \@f);
    }
}
$logger->info(scalar(@Present), " presents, ", scalar(@Region), " regions");

$logger->debug("(Covers ", $_->coverCount, ") ", $_->show) for @Present;

# Sanity check: is it even possible to leave any space with these quantities of presents?
my $impossible = 0;
for my $reg ( @Region )
{
    my $cover = 0;
    for my ($i,$q) ( indexed $reg->quantity )
    {
        $cover += $q * $Present[$i]->cover;
    }
    $impossible++ if $cover > $reg->area;
    $logger->debug("Region area=", $reg->area, " cover=$cover");
}
$logger->info("IMPOSSIBLE? $impossible regions don't have enough area");

say @Region - $impossible;

$logger->info("FINISH");
