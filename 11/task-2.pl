#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-2.pl Advent of Code 2025 Day 11 Part 2  Reactor
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
my $Start = "svr";
my $End   = "out";
my $Via   = "dac,fft";
AOC::setup( { "start:s" => \$Start, "end:s" => \$End, "via:s" => \$Via } );
$Via = [ split(/[, ]/,  $Via) ];

use List::Util qw/all/;

$logger->info("START");


my %Graph;
{
    while (<>) {
        chomp;
        my ($from, @to) = split /:? /;

        push @{$Graph{$from}}, @to;
    }
}
$logger->info("Graph has ", scalar(keys(%Graph)), " nodes");
$logger->info("SEARCH from $Start to $End, via ", join(",", $Via->@*) );

my $dacfft = findPath(\%Graph, $Start, $End, $Via );

say $dacfft;

$logger->info("FINISH");
########################################################################
sub findPath($graph, $start, $end, $via)
{
    fp($graph, "", $start, $end,
                  { map { $_ => false } $via->@* }, { $start => false } );
}

sub fp($graph, $depth, $node, $end, $sawVia, $visited)
{
    state %cache;
    my $count = 0;

    my $key = join("-", $node, grep { $sawVia->{$_} } sort keys %$sawVia);
    $logger->debug("$depth FIND at $node count=$count key=$key");
    if ( exists $cache{$key} )
    {
        $logger->debug("$depth CACHE $node=$cache{$key}");
        return $cache{$key}
    }

    $sawVia->{$node} = true if exists $sawVia->{$node};

    for my $neighbor ( $graph->{$node}->@* )
    {
        if ( exists $visited->{$neighbor} )
        {
            $logger->debug("$depth CYCLE revisited $neighbor");
            next;
        }

        $logger->debug("$depth $node");
        if ( $neighbor eq $end )
        {
            $logger->debug("$depth Found $end, count=$count");
            $count += ( all { $_ } values %$sawVia ) ? 1 : 0;
        }
        else
        {
            $count += fp($graph, "--$depth", $neighbor, $end,
                          { %$sawVia }, { %$visited, $node => true } );
        }
    }
    $cache{$key} = $count;
    return $count;
}

