# Advent of Code 2025 Day 7
[Laboratories](https://adventofcode.com/2025/day/7

## Task 1

- The input always has a space on either side of a splitter.

- We don't need the whole grid, only a current row, plus the splitters from
the next row.

- Find the beams in the current row, look at the row below, place the beams
either on the sides of the splitters or directly below.

- Don't forget to count the number of splits.

## Task 2

- Count the beams, instead of the splits. In each column, record the number
of times a beam passes through.

- At each split, add the incoming count to the count on the left and right of the splitter.

- The splitters themselves can't be reached, so that column count becomes 0.

- Still only need a row and the row below it, not the grid or tree.
