# Advent of Code 2025 Day 8
[Playground](https://adventofcode.com/2025/day/8

## Task 1

Every pair of distances between 1000 points is 499,500 combinations.
Not unreasonable to calculate them all and hold in memory.

- Useful to have a Point class.

- Use a priority queue to process in order by distance. Maybe could have
just sorted? The values in the queue are pairs of Points; the weight is
the distance between them.

- Accumulate an array of circuits. Each circuit is a hash table for fast
lookup of the points that are in it. Make a class around the collection.

- Three possibilities for adding a pair:
  - Haven't seen either point: push a new circuit onto the array
  - Both oints exist in two different circuits: merge the 2nd circuit into the first
  - One point exists in a circuit: add the other point to that circuit


## Task 2

- Set the limit past 499,500 and place every pair into a circuit.

- Stop if the size of the first circuit hits the number of boxes.

- Nastiest data would be to have to get to pair number 499,500 before the
circuit is complete. That would take about 2 minutes to calculate. Turns
out that the data is such that it completes much faster than that.
