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

#automatically listing the contents of
#the file repository currently in use

#read the permissions 
ls -l
#pipe w's from permissions (use space as delimeter)
# into recursive if statement
#if permission is assigned to user running the script then print
#cat?
