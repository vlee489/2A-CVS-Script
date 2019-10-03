#!/usr/bin/env bash

# Menu
echo "Option 1) Open a file repository"
echo "Option 2) Create a new file repository"
echo "Option 3) Quit"
read -p "Please enter an option: " option
case $option in
  1 ) echo "You entered one, open a file repository"
  ;;
  2 ) echo "You entered two, create a new file repository:"
  ;;
  3 ) echo "Goodbye!"
  ;;
  *) echo "You entered a number not between 1 and 3."
esac
