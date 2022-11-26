#!/bin/bash

if [[ $2 == "rel" ]] || [[ $2 == "test-rel" ]]; then
  echo "### RELEASE BUILD ###"
  dotnet build -c Release
else
  dotnet build
fi

echo
export part=$1
if [[ $2 == "test" ]] || [[ $2 == "test-rel" ]]; then
  echo "### TEST MODE ###"
  export mode=test
fi
time ./bin/Release/net7.0/Aoc
