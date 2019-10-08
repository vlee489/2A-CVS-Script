#!/usr/bin/env bash
file="NULL"; 
back=false;
option=null;
selectedRepo=""
##Make a menu ask whether they want to edit,create,delete or exit text file 
clear
ls -l

echo "Option 1) Edit an existing text file "
echo "Option 2) Create a new Text file"
echo "Option 3) Delete a text file"
echo "Option 0) Exit "
read -p "Please enter an option: " option



editFile(){
echo "What file would you like to edit"
    ls 
    read file
    if [ -f $file ] ;then
	chmod 244 "$file" # Only changes user i can't seem  to change the other people permissions UGO doesn't seem to work 
	vi $file ## or allow user to type stuff cat show and then sed "text"
      
      chmod 444 "$file" ## Change it back to read only chmod 222 or the 0ther ones
	    ##// Log changes in a log file DUnno ??????
          ls -l
    else
   	    echo "The file '$file' in not found"
          echo "Sending back to menu"  
    fi
}

createFile(){
    read file 
    ## Chmod repostiry  
    touch $file  
}

deleteFile(){
      read file
      if [ -f $file ] ;then
            rm $file
            echo "You have deleted the file '$file'"
      else
             echo "The file '$file' in not found"
             echo "Sending back to menu"  
      fi
      #loop menu      
}


case $option in
  1 ) echo "You entered one, open a file repository"
      editFile
 ;;
  2 ) echo "You entered two, What would you like to call the file:"        
      createFile
  ;;
  3 ) echo "You entered three, Which file would you like to delete"
      deleteFile
  ;;
  *) echo "You entered a number not between 1 and 3."
esac

##Maybe move while for whole thing instead of 1




