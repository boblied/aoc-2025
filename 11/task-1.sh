#!/bin/ksh

# Convert the input from stdin into Graphviz format.

echo "digraph {" > j.gv

sed -e 's/://' -e 's/ / -> /g' -e 's/$/;/' >> j.gv

echo "}" >> j.gv

dot -Tpng j.gv > j.png

open j.png
