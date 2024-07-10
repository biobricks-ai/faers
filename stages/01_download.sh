#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Create the list directory to save list of remote files and directories
listpath="$localpath/list"
echo "List path: $listpath"
mkdir -p "$listpath"
cd "$listpath" || exit;

URL="https://fis.fda.gov/content/Exports/"
wget --no-remove-listing https://fis.fda.gov/extensions/FPD-QDE-FAERS/FPD-QDE-FAERS.html
cat FPD-QDE-FAERS.html | grep -Po '(?<=href=")[^"]*ascii[^"]*\.zip' | sort | cut -d "/" -f 6 > files.txt
rm "$localpath"/FPD-QDE-FAERS.html

downloadpath="$localpath/download"
echo "Download path: $downloadpath"
mkdir -p "$downloadpath"
cd "$downloadpath" || exit;

# Download files in parallel
cat "$listpath"/files.txt | xargs -P14 -n1 bash -c '
echo $URL$1
wget -nH -q -nc -P '$downloadpath' '$URL'$1' {}

echo "Download done."
