#!/bin/bash
# HOW to use? Just type in...
# $bash randsp_v0.4.sh yourFilePath

# v0.4 remove unrelated annotations, release to the team.

file=$1
echo ""
echo "starting $0..."
echo "your target file is: $file"; echo ""
read -p "calculate the row number? (y/n)" wcl

if [[ "$wcl" == "y" ]]
then
  echo "calculating row number..."
  echo -n "row number= "; cat $file | wc -l; echo ""
fi

echo "showing head and tail..."
echo "===== head of file ===== " ; head $file; echo ""
echo "===== tail of file ====="; tail $file
read -p "remove how many rows from HEAD (input: int >=0)?" headrmno
read -p "remove how many rows from TAIL (input: int >=0)?" tailrmno
read -p "then, randomly select how many rows (input: int >=0)?" nn

echo "random sampling..."
declare -i headnewstart=$headrmno+1
declare -i tailtrpoint=$tailrmno
declare -i numofrow=$nn

tail -n +$headnewstart $file | head -n -$tailtrpoint > shuf -n $numofrow > ./$file-randsp-$numofrow-$(date +%Y%m%d).csv
echo "sampling complete"
echo "program end"
