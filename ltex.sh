#!/bin/bash

# ltex - github.com/abelsiqueira/ltex
# Copyright (C) 2016  Abel Soares Siqueira
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
