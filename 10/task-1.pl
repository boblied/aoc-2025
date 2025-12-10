#!/usr/bin/env perl
# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# task-1.pl Advent of Code 2025 Day 10 Part 1  Factory
#=============================================================================

use v5.42;
use FindBin qw($Bin); use lib "$FindBin::Bin/../../lib"; use AOC;
AOC::setup;

use Feature::Compat::Class;
say "LOGGER: ", $logger->category;
class Machine
{
    use Log::Log4perl qw/get_logger/;
    field $logger;

    field $indicator :param :reader;
    field $schematic :param :reader;
    field $joltage   :param :reader;

    field $display;  # Bit vector from indicator
    field @button;   # Bit vectors from schematic
    # field @joltage? # TBD

    ADJUST {
        $logger = get_logger("AOC");
        $display = oct("0b".((reverse $indicator) =~ tr/.#/01/r));

        @button = map { listToBit($_) } split(" ", $schematic);
    }

    sub listToBit($str)
    {
        my $bit;
        $bit |= (1 << ($_)) for split(",", $str);
        return $bit;
    }

    sub b($n) { sprintf("%10b", $n) }

    method show() {
        my @s = ( sprintf("[%b]", $display) );
        push @s, sprintf("(%b)", $_) for @button;
        return join(" ", @s);
    }
    use overload '""' => sub { $_[0]->show() };

    method smash() {
        my @stack;
        push @stack, [ 0, 0 ] for @button;
        my %seen;

        while ( my $x = shift @stack )
        {
            my ($path, $lights) = @$x;
            $logger->debug("Check ", b($display), " =?= ", b($lights), " at step $path");

            if ( $lights == $display )
            {
                $logger->debug("Found ", b($display), " at step $path");
                return $path;
            }

            $seen{$lights} = true;

            for ( @button )
            {
                my $toggle = ($lights ^ $_);

                next if ( $seen{$toggle} );
                $seen{$toggle} = true;

                if ( $toggle == $display )
                {
                    $logger->debug("Found ", b($display), " at step ", $path+1);
                    return $path+1
                }

                push @stack, [ $path+1, $toggle ]; 
            }
        }
        return 0;
    }
}

$logger->info("START");

my @Factory;
while (<>)
{
    chomp;
    s/[(){}[\]]//g;
    my @field = split;

    my $indicator = shift @field;
    my $joltage   = pop @field;
    my $schematic = join(" ", @field);

    push @Factory, Machine->new(indicator => $indicator, schematic => $schematic, joltage => $joltage);
}
$logger->debug( $Factory[0]->show() );
$logger->debug( $Factory[-1]->show() );

my $Total = 0;
for my $machine ( @Factory )
{
    my $press = $machine->smash();
    $logger->debug("PRESS $press times for $machine");
    $Total += $press;
}

say $Total;


$logger->info("FINISH");
