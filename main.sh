#!/usr/bin/env bash

# Menu
echo "Option 1) Open a file repository"
echo "Option 2) Create a new file repository"
echo "Option 0) Quit"
read -p "Please enter an option: " option


while true
do
case $option in
  1 ) echo "You entered one, open a file repository"

  echo "Option 1) Edit a file"
  echo "Option 2) Create a new file in the repository"
  echo "Option 3) Delete a file"
  echo "Option 0) Quit"
  read -p "Please enter an option: " choice

  while true
  do
  case $choice in

    1) echo"You entered one, edit a file."
      editFile
      ;;
    2) echo"You entered two, what would you like to call the file?"
      createFile
      ;;
    3) echo"You entered three, which file would you like to delete?"
      deleteFile
      ;;
    0 ) echo "Goodbye!"
    break
    ;;
  done
  2 ) echo "You entered two, create a new file repository:"
  ;;
  0 ) echo "Goodbye!"
  break
  ;;
  *) echo "You entered a number not between 1 and 3."
esac
done

#automatically listing the contents of
#the file repository currently in use

#read the permissions (file type (1), user persmissions(3),
#group permissions (3), other permissions(3), lecture 7 notes)
ls -l

#pipe w's from permissions (use space as delimeter)
#need to use a while loop to ensure every single line is read in the file
mkfifo mypipe
#Where 2 is the field number of the space-delimited field you want.
cut -d '' -f 2

while read line
do
  echo "LINE: $line"
done < /dev/stdin


#using a pipe:
STDIN
STDOUT

# into recursive if statement
if[permission is assigned to user running the script then print, commands]
then
  #commands
  echo ""
else
  echo "No permissions were found"
fi


#cat? is only good for shorter files use the 'less' command
#(allows scrolling up and down, press q to exit to command line)

#use the 'sort' command to filter the file contents. try 'help' to
#find any versions that may be relevant.

#Zip a repository
zipRepo(){
  echo "Please ensure you are located in the correct directory before zipping"
  zip -r "$SelectedRepoName.zip" $selectedRepo
}
