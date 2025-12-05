# vim:set ts=4 sw=4 sts=4 et ai wm=0 nu:
#=============================================================================
# Range.pm
#=============================================================================
# Copyright (c) 2025, Bob Lied
#=============================================================================
# Description:
#=============================================================================

use v5.42;
use Feature::Compat::Class;


class AOC::Range;

use List::Util qw/min max/;

use constant { LOWER => 0, UPPER => 1 };

field @range;

method add($lower, $upper)
{
    if ( @range == 0 )
    {
        push @range, [$lower, $upper];
        return
    }
    if ( $upper < $range[0][LOWER] )
    {
        unshift @range, [$lower, $upper];
        return;
    }
    if ( $lower > $range[-1][UPPER] )
    {
        push @range, [$lower, $upper];
        return;
    }

    my @temp;
    while ( defined( my $r = shift @range ) )
    {
        if ( canMerge(@$r, $lower, $upper) )
        {
            $lower = min($r->[LOWER], $lower);
            $upper = max($r->[UPPER], $upper);
        }
        else { push @temp, $r }
    }
    @range = sort { $a->[LOWER] <=> $b->[LOWER] } @temp, [$lower, $upper];
}

method total()
{
    use List::Util qw/sum/;
    return List::Util::sum map { $_->[UPPER] - $_->[LOWER] + 1 } @range
}

sub canMerge($beg1, $end1, $beg2, $end2)
{
    ($end2 >= $beg1 && $beg2 <= $end1)  # Overlap
    || $end1 == $beg2-1                 # Adjacent on the left
    || $end2 == $beg1-1                 # Adjacent on the right
}

method show()
{
    join ",", map { "[".$_->[LOWER]."-".$_->[UPPER]."]" } @range;
}

method find($val)
{
    if ( $val < $range[0][LOWER] || $val > $range[-1][UPPER] )
    {
        return false;
    }
    my $r = 0;
    $r++ while $r <= $#range && $val > $range[$r][UPPER];
    
    return $range[$r][LOWER] <= $val <= $range[$r][UPPER];
}

true;
