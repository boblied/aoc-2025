#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 4 Part 2
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use AOC::Grid;

$logger->info("START");

my $total = 0;
my $Room = AOC::Grid->loadGrid();
while ( my $roll = remove($Room) )
{
    $total += $roll; 
}
say $total;

sub remove($room)
{
    my $count = 0;
    for my $row ( 0 .. $Room->height )
    {
        for my $col ( 0 .. $Room->width )
        {
            if ( $Room->get($row, $col) eq "@"
               && ( (grep /@/, map { $_->[0] } $Room->aroundAll($row,$col)) < 4 ) )
            {
                $count++;
                $room->set($row, $col, 'x');
            }
        }
    }
    return $count;
}

$logger->info("FINISH");
