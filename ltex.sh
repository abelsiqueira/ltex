#!/bin/bash

function textree() {
  local main=$1
  local level=$2
  [ -z "$level" ] && level=1
  #grep -E "(include|input){" $main | sed 's/\\\(include\|input\){\(.*\)}/\2.tex/g'
  for f in $(grep -E "(include|input){" $main | sed 's/\\\(include\|input\){\(.*\)}/\2.tex/g')
  do
    for i in $(seq 2 $level)
    do
      echo -n "  "
    done
    echo "> $f"
    textree $f $[level+1]
  done
}

if [ $# -eq 1 ]; then
  files=$@
else
  files=$(grep -l documentclass *.tex)
fi

if [ -z "$files" ]; then
  echo "I can't find any .tex files in this folder"
  exit 3
fi

for main in $files
do
  main=$(basename $main .tex).tex
  echo $main
  textree $main
done
