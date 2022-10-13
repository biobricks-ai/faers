#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Create the list directory to save list of remote files and directories
listpath="$localpath/list"
echo "List path: $listpath"
mkdir -p $listpath
cd $listpath;

# Create the download directory
downloadpath="$localpath/download"
echo "Download path: $downloadpath"
mkdir -p "$downloadpath"
cd $downloadpath;

# Download files
URL="https://fis.fda.gov/content/Exports/"
Year=2004
Quarter=1
FileName="aers_ascii_${Year}q${Quarter}.zip"
while true;
do
  if ! wget --spider -w 2 -t 2 "$URL$FileName" 2>/dev/null; 
  then
    break
  fi
  echo $FileName
  echo $FileName >> "${listpath}/files.txt"
  if [[ $Quarter -ge 4 ]] 
  then
    let Year=$Year+1
    Quarter=1
  else
    let Quarter=$Quarter+1
  fi
  FileName="aers_ascii_${Year}q${Quarter}.zip"
done
Year=2012
Quarter=4
FileName="faers_ascii_${Year}q${Quarter}.zip"
while true;
do
  if ! wget --spider -w 2 -t 2 "$URL$FileName" 2>/dev/null; 
  then
    break
  fi
  echo $FileName
  echo $FileName >> "${listpath}/files.txt"
  if [[ $Quarter -ge 4 ]] 
  then
    let Year=$Year+1
    Quarter=1
  else
    let Quarter=$Quarter+1
  fi
  FileName="faers_ascii_${Year}q${Quarter}.zip"
done

# Download files in parallel
cat $listpath/files.txt | xargs -P14 -n1 bash -c '
echo $1
wget -nH -q -nc -P '$downloadpath' '$URL'$1' {}

echo "Download done."
