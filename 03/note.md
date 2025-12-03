# Advent of Code 2025 Day 3
[Lobby](https://adventofcode.com/2025/day/3

## Part 1

Scan for the max digit (not including the last).
To exclude the last, pop it off the list temporarily, then restore it.
From that point, slice the rest of the list and scan for the max digit again.

## Part 2

Generalize. For 11 to 0, remove the tail (so that enough digits are left).
 - Find the first max digit.
 - Remove the front of the list to that index and restore the tail for the next search.

Using `splice` to remove the tail, instead of `pop` in part 1. When we get to
splice(@bank, 0), that would empty @bank, so handle that.

Removing the prefix reduces the size of the list that we have to search.
Even though we're searching 12 times for each number, each search gets smaller.
