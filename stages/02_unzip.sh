#!/usr/bin/env bash

# Script to unzip files

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Set download path
downloadpath="$localpath/download"
echo "Download path: $downloadpath"

# Set list path
listpath="$localpath/list"
echo "List path: $listpath"

# Create raw path
rawpath="$localpath/raw"
mkdir -p $rawpath
echo "Raw path: $rawpath"

# Unzip files in parallel
# NOTE: previously piped through `head -n -3`, which silently dropped the 3
# newest quarters from the build. Use the full list (sorted-unique) so every
# downloaded quarter is unzipped. -o -q makes re-runs non-interactive.
sort -u $listpath/files.txt | xargs -P14 -n1 bash -c '
  filename=$(basename "$1" .zip)
  echo '$downloadpath'/$1
  echo '$rawpath'/$filename
  unzip -o -q '$downloadpath'/$1 -d '$rawpath'/$filename
' {}