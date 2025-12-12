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

# my $dacfft = findPath(\%Graph, $Start, $End, $Via );
my $dacfft = traverse(\%Graph, "svr", false, false, {} );

say $dacfft;

sub traverse($graph, $node, $dac, $fft, $seen)
{
    state %cache;

    if ( $node eq 'out' )
    {
        return ($dac && $fft) ? 1 : 0;
    }

    my $key = join("-", $node, ($dac ? "T" : "F"), ($fft ? "T" : "F") );
    return $cache{$key} if $cache{$key};

    $seen->{$node} = true;

    my $sum = 0;
    for my $next ( $graph->{$node}->@* )
    {
        next if $seen->{$next};
        $sum += traverse($graph, $next,
                        ($dac || $node eq "dac"), ($fft || $node eq "fft"),
                        { %$seen } ); 
    }
    return $cache{$key} = $sum;
}


sub findPath($graph, $start, $end, $via)
{
    my $pathCount = 0;

    my @stack = ( [ "", $start, { $start => true } ] );

    while ( my $x = pop @stack )
    {
        my ($depth, $node, $seen) = $x->@*;
        $seen->{$node} = true;
        for my $neighbor ( $graph->{$node}->@* )
        {
            $logger->debug("$depth $node -> $neighbor");
            next if $seen->{$neighbor};

            if ( $neighbor eq $end )
            {
                $pathCount++;
                $logger->debug("$depth Found $end, count=$pathCount");
            }
            else
            {
                push @stack, [ "--$depth", $neighbor, { %$seen }];
            }
        }
        $logger->debug("Stack depth is ", scalar(@stack));
    }
    return $pathCount;
}
$logger->info("FINISH");
