#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 4 Part 1
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;
use AOC::Grid;

$logger->info("START");

my $Room = AOC::Grid::loadGrid();
$logger->info($Room->show);

my $canMove = 0;
for my $row ( 0 .. $Room->height )
{
    for my $col ( 0 .. $Room->width )
    {
        $canMove++ if $Room->get($row, $col) eq "@"
                   && ( (grep /@/, map { $_->[0] } $Room->aroundAll($row,$col)) < 4 );
    }
}
say $canMove;

$logger->info("FINISH");
