#!/bin/bash
#this is a spinner script 
arr=('-' '\' '|' '/')
while true;
do 
	for a in "${arr[@]}";
	do
		echo -en "\r $a"
		sleep .5
	done
done
