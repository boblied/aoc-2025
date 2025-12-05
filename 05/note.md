# Advent of Code 2025 Day 5
[Cafeteria](https://adventofcode.com/2025/day/5

## Task 1

For each new range, merge it with anything that overlaps or is adjacent. Keep the
list of ranges sorted. Simple linear lookup for each ingredient.

Merging the ranges combines 178 in the input to 76 at lookup time.

Considered turning this into a tree for faster lookup, but it was nearly
instantaneous as is.

## Task 2

Having the ranges from step 1, add them up. Add a total() method to the Range class.
