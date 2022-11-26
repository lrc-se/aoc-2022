#!/bin/bash

export part=$1
if [[ $2 == "test" ]]; then
  echo "### TEST MODE ###"
  export mode=test
fi
time py aoc.py
