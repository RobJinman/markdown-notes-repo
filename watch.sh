#!/bin/bash

tab=0

# Offset echo by the number tab spaces held in $tab
oecho() {
  tabs=""
  if [ "$tab" -gt 0 ]
  then
    tabs=$(printf "\t%.0s" {0..$tab})
  fi
  echo -e "$tabs$1"
}

# $1 Input file (.md extension)
# $2 Output file (.html extension)
build() {
  oecho "Building..."
  ((tab++))

  oecho "Source file: $1"
  oecho "Destination file: $2"

  srcFile="$1"
  dstFile="$2"

  dstDir=${dstFile%/*}

  oecho "Creating directory $dstDir"
  mkdir -p "$dstDir"

  oecho "Processing $srcFile -> $dstFile"
  pandoc -s -o "$dstFile" "$srcFile"

  ((tab--))
}

# Searches src directory and runs build() on new or recently
# modified files
buildAllModified() {
  oecho "Scanning for modified source files..."
  ((tab++))

  srcFiles=$(find src -name "*.md")

  for srcFile in $srcFiles
  do
    relPath=${srcFile#src/}
    strippedRelPath=${relPath%.md}
    dstFile="build/${strippedRelPath}.html"

    if [ -f "$dstFile" ]
    then
      t1=$(stat -c %Y "$srcFile")
      t2=$(stat -c %Y "$dstFile")

      if [ "$t1" -gt "$t2" ]
      then
        oecho  "$srcFile is more recent than $dstFile."
        build "$srcFile" "$dstFile"
      fi
    else
      oecho "$dstFile does not yet exist"
      build "$srcFile" "$dstFile"
    fi
  done

  ((tab--))
}

# Searches build directory, removing any files that lack a
# corresponding file in src
deleteRedundant() {
  oecho "Deleting redundant files..."
  ((tab++))

  dstFiles=$(find build -name "*.html")

  for dstFile in $dstFiles
  do
    relPath=${dstFile#build/}
    strippedRelPath=${relPath%.html}
    srcFile="src/${strippedRelPath}.md"

    if [ ! -f "$srcFile" ]
    then
      oecho "$srcFile does not exist"
      oecho "Deleting corresponding html file $dstFile"

      rm -r "$dstFile"
    fi
  done

  ((tab--))
}

# Run immediately
buildAllModified
deleteRedundant

# Wait for changes to src directory
while true
do
  change=$(inotifywait --recursive --event modify,create,move,delete src)
  echo $change

  buildAllModified
  deleteRedundant
done
