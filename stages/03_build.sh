#!/usr/bin/env bash

# Script to process unzipped files and build parquet files

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Set list path
listpath="$localpath/list"
echo "List path: $listpath"

# Set raw path
rawpath="$localpath/raw"
echo "Raw path: $rawpath"

# Create brick directory
brickpath="$localpath/brick"
mkdir -p $brickpath
echo "Brick path: $brickpath"

# Process raw files and create parquet files in parallel
# calling a Python function with arguments input and output filenames
for class in drug demo indi outc reac rpsr
do
  mkdir -p $brickpath/$class.parquet
  index=0
  for infile in `find $rawpath -type f -iname $class*.txt | sort`
  do
    outfile="$brickpath/$class.parquet/$class`printf %03d $index`.parquet"
    python stages/csv2parquet.py $infile $outfile 
    let index=$index+1
  done
done
