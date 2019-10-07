#!/usr/bin/env bash
file=NULL; 
back=false;
option=null;
##Make a menu ask whether they want to edit,create,delete or exit text file 
clear
ls

echo "Option 1) Edit an existing text file "
echo "Option 2) Create a new Text file"
echo "Option 3) Delete a text file"
echo "Option 0) Exit "
read -p "Please enter an option: " option


case $option in
  1 ) echo "You entered one, open a file repository"
    ls
    while !back do:
    echo "What file would you like to edit"
    read $file
    if [ -f $file ]; then

	   chmod u+w $file; # Only changes user i can't seem  to change the other people permissions
	    vi $file ## or allow user to type stuff cat show and then sed "text"
	    ## cp current location to backup location ## Back up ????? create copy and move to .backup ???  
	     chmod u-w ## Needs checking
         chmod u+r ## Change it back to read only chmod 222 or the 0ther ones
	    // Log changes in a log file DUnno ??????
	    back=true;

    else
   	    echo "The file '$file' in not found"
    fi

if[ $file= "0" ]; then
    back=true;
fi
;done
  ;;
  2 ) echo "You entered two, What would you like to call the file:"        
        read file 
        touch $file 
  ;;
  3 ) echo "You entered three, Which file would you like to delete"
        read file
        rm $file
  ;;
  *) echo "You entered a number not between 1 and 3."
esac
##Maybe move while for whole thing instead of 1




