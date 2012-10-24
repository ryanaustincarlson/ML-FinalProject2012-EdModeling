#!/usr/bin/env bash

# examples of commands to run
# run this script (from the terminal, type ./runme.sh) to run each of these in sequence

cd extraction-and-formatting
python extract-logdata.py ../data/alldata.csv ../output/processed.csv
cd ..
