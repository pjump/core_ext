#!/bin/bash

#Usage: collect_test_results success_heap.txt failing_heap.txt [result1 result2 ... ]

success_heap=$1
failing_heap=$2
touch "$1" "$2"

shift; shift

for arg in "$@"
do
  if tail -1 "$arg" | grep -q "^Failed"
  then
    cat "$arg" >> "$failing_heap"
  else
    cat "$arg" >> "$success_heap"
  fi
done
