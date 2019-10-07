#!/usr/bin/env bash
file=NULL; 
back=false;

##Make a menu ask whether they want to edit,create,delete or exit text file 
clear
ls


##Maybe move while for whole thing instead of 1

// if 1 is selected
    clear
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

Go to previous menu

// if 2 is selected 
echo "what would you like to call the file" 
read file 
touch $file 
//go back to menu

## if 3 is selected  
##rm $file
## go back to menu

## chmod -R +r directory Changes everything in directory to readonly 