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

#read the permissions (file type (1), user persmissions(3),
#group permissions (3), other permissions(3), lecture 7 notes)
ls -l

#pipe w's from permissions (use space as delimeter)
#need to use a while loop to ensure every single line is read in the file
mkfifo mypipe

while read line
do
echo "LINE: $line"
done < /dev/stdin


#using a pipe:
STDIN
STDOUT

# into recursive if statement
if(permission is assigned to user running the script then print, commands)
then
#commands
echo ""
fi


#cat? is only good for shorter files use the 'less' command
#(allows scrolling up and down, press q to exit to command line)

#use the 'sort' command to filter the file contents. try 'help' to
#find any versions that may be relevant.
