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
