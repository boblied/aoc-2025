# Advent of Code 2025 Day 11
[Reactor](https://adventofcode.com/2025/day/11

## Part 1

Find every path from start node to end node? That's just classic
graph algorithms.

Checking the input, it looks like a directed acyclic graph. Piece of cake.

Quickly running the input through graphviz shows that there 6 clusters,
connected by what looks like four edges.  I have a bad feeling about part 2.

## Part 2

 - Add a list of nodes that must be included to the search.
 - Include that on the stack.
 - When we reach "out", check that all the 'via' nodes have been seen.

Works beautifully for the example, but of course, the input has
some kind of combinatorial explosion that does not complete in reasonable time.

Tried going backward from out to svr, but no.

The input graph is not acyclic. There's a loop, for example, between rcv and ora.
