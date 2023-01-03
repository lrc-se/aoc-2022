#!/bin/bash

if [[ $2 == "rel" ]] || [[ $2 == "test-rel" ]]; then
  echo "### RELEASE BUILD ###"
  ./build.sh
else
  nim c --outdir:nimcache aoc.nim
fi

echo
export part=$1
if [[ $2 == "test" ]] || [[ $2 == "test-rel" ]]; then
  echo "### TEST MODE ###"
  export mode=test
fi
time ./nimcache/aoc
