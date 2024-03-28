#!/bin/bash
#script for second countdown, for testing 

echo "This script will execute after a countdown."
echo "Please enter the dr of the countdown in seconds:"
read -r dr
#waits for the user inputs

if [[ ! $dr =~ ^[0-9]+$ ]]; 
then
  echo "Invalid input. Please enter a valid number."
  exit 1
fi

echo "Countdown starting..."

for ((sec=dr; sec>=1; sec--)); 
do
    echo -ne "Seconds remaining: $sec \r"
    sleep 1
done
echo "oh great! job"

: '
#starting of multi line comment
#script for predefined execution time

echo "This script will execute after a countdown."
echo "Press Enter to start the countdown..."
read -r
#wait for the user input

echo "Countdown starting..."

for ((sec=5; sec>=1; sec--)); 
do
    echo -ne "Seconds remaining: $sec \r"
    sleep 1
done

echo "Executing the script!"
'
