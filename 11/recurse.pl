sub fp($graph, $depth, $node, $end, $sawVia, $visited)
{
    state %cache;
    my $count = 0;

    my $key = join("-", $node, grep { $sawVia->{$_} } sort keys %$sawVia);
    $logger->debug("$depth FIND at $node count=$count key=$key");
    if ( exists $cache{$key} )
    {
        $logger->debug("$depth CACHE $node=$cache{$node}");
        return $cache{$node}
    }

    $sawVia->{$node} = true if exists $sawVia->{$node};

    for my $neighbor ( $graph->{$node}->@* )
    {
        next if exists $visited->{$neighbor};
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

sub find($graph, $start, $end, $via)
{
    fp($graph, "", $start, $end,
                  { map { $_ => false } $via->@* }, { $start => true } );

}
