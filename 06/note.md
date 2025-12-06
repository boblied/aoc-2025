# Advent of Code 2025 Day 6
[Trash Compactor ](https://adventofcode.com/2025/day/6

## Task 1

First impression: doesn't look that hard. Probably big numbers with possibiity of overflow.
Read into an array, extract the columns, apply the operator.

## Task 2

Notice that the input is in fixed-column format. The operators in the last row
line up with the beginning of the columns, so use that to figure out the field
locations.
