#!/usr/bin/env bash
file="NULL";
repoFolder="Repositories"
configFolder=".CVSConfigs"
back=false;
option=null;
selectedRepo="Repositories"
selectedRepoName="Repositories"
noRepo=false
baseFolder=$(pwd)

#Zip a repository
zipRepo(){
  echo "Please ensure you are located in the correct directory before zipping"
  zip -r "$SelectedRepoName.zip" $selectedRepo
}

makeRepo(){
  echo "We're going to walk you through making a new repo"
  local newRepoName=""
  local newRepoDir=""
  local valid=false
  while [ $valid == false ]; do
    read -p "Enter name of the new repo: " newRepoName
    if [ -d "$repoFolder/$newRepoName" ]; then
      echo "Invalid repo name"
      echo "Folder likely already exists"
    else
        # make repo and set perms
        chmod 777 $repoFolder
        mkdir $repoFolder/$newRepoName
        touch "$repoFolder/$newRepoName/.log.txt"
        mkdir "$repoFolder/$newRepoName/.backup"
        chmod -R 551 $repoFolder/$newRepoName
        chmod 551 $repoFolder
        valid=true
        newRepoDir="\"$PWD/$repoFolder/$newRepoName\""
        echo "$newRepoDir~$newRepoName" >> "$configFolder/"repos.txt""
        echo "New Repo Added"
        selectedRepo="$PWD/$repoFolder/$newRepoName"
    fi
    done
}

openRepo(){
  valid=false
  if [ -s "$configFolder/"repos.txt"" ]; then
    echo "List of Repositories"
    echo "===================="
  else
    echo "No Repo Available"
    noRepo=true
  fi
  # While loops if a valid choice hasn't been given and the repo txt file has repos to show
  while [ $valid == false ] && [ $noRepo == false ]; do
    local optionNumbers=0
    userChoice=""
    # following while loop shows available options from the txt file
    # IFS is the internal field separator and is used to split strings in
    # bash, here we use it to split it per line
    while IFS= read -r line
    do
      optionNumbers=$((optionNumbers + 1))
      IFS='~' read -ra repoName <<< "$line"
      echo "$optionNumbers) ${repoName[1]}"
    done <"$configFolder/"repos.txt""
    optionNumbers=$((optionNumbers + 1))
    read -p "Enter number to open repo: " userChoice
    # if user choice is valid
    if [ $userChoice -lt $optionNumbers ] && [ $userChoice -gt 0 ]; then
      # get x line from txt file
      selectedOption=$(sed "${userChoice}q;d" "$configFolder/"repos.txt"")
      # Split using delimiter
      IFS='~' read -ra repoName <<< "$selectedOption"
      echo "You've selected the Repository: ${repoName[1]}"
      # Place repo dir in variable while removing speech marks from either end of string
      selectedRepo=$(sed -e 's/^"//' -e 's/"$//' <<<"${repoName[0]}")
      valid=true
    else
      echo "Invalid Choice!"
      selectedRepo=""
    fi
  done
}

deleteRepo(){
  echo "Please select a Repository to delete!"
  openRepo # Used to select repo
  if [ $noRepo == false ]; then
    echo "Are you sure you want to delete $selectedRepoName?"
    read -p "yes / no: " confirm
    if [ $confirm == "yes" ] || [ $confirm == "y" ]; then
      deleteTime=$(date +%s) # Gets current time
      # Make repo to store backup
      mkdir "$(pwd)/$configFolder/.repoRecovery/$deleteTime"
      chmod 777 $repoFolder
      chmod -R 777 $selectedRepo
      # Move delted repo to backup
      mv $selectedRepo "$configFolder/.repoRecovery/$deleteTime"
      # Add deleted repo to the txt file containing removed repos in backup folder
      echo "\"$(pwd)/$configFolder/".repoRecovery"/$deleteTime\"~$deleteTime~${repoName[1]}" >> "$configFolder/"removedRepo.txt""
      #Remove repo for repos.txt
      sed -i.bak "${userChoice}d" "$(pwd)/$configFolder/"repos.txt""
      rm -rf "$(pwd)/$configFolder/"repos.txt.bak""
      chmod -R 551 "$configFolder/.repoRecovery/$deleteTime"
      chmod 551 $repoFolder
      echo "Deleted Repository: ${repoName[1]}"
    else
      echo "Aborting Repository deletion"
    fi
  fi
}

# actually Deletes any Repository backups older than a week
# Used to automatically remove backups at start of script
autobBackupRemoval(){
  if [ -s "$configFolder/"removedRepo.txt"" ]; then # Checks if txt file has txt
    local counter=0
    # Read each line for txt file
    while IFS= read -r line
    do
      counter=$((counter + 1))
      IFS='~' read -ra repoCheck <<< "$line"
      #Data of repo deletion plus 7 days
      checktime=$((${repoCheck[1]}+604800))
      deleteTime=$(date +%s)
      # If repo backup is older than 7 days, it deletes the repo
      if (( $checktime < $deleteTime )); then
        chmod -R 777 $(sed -e 's/^"//' -e 's/"$//' <<<"${repoCheck[0]}")
        rm -rf $(sed -e 's/^"//' -e 's/"$//' <<<"${repoCheck[0]}")
        sed -i.bak "${counter}d" "$(pwd)/$configFolder/"removedRepo.txt""
        rm -rf "$(pwd)/$configFolder/"removedRepo.txt.bak""
      fi
    done <"$configFolder/"removedRepo.txt""
  fi
}

recoverRepository(){
  if [ -s "$configFolder/"removedRepo.txt"" ]; then # Checks if txt file has txt
    #Like the openRepo function, it opens the txt file containing the backedup repos
    # and then displays them to allow the user to choose wich one to recover
    local optionNumbers=0
    local userOption
    while IFS= read -r line
    do
      optionNumbers=$((optionNumbers + 1))
      IFS='~' read -ra repoName <<< "$line"
      echo "$optionNumbers) ${repoName[2]}"
    done <"$configFolder/"removedRepo.txt""
    optionNumbers=$((optionNumbers + 1))
    read -p "Enter number of the repo you want to recover: " userOption
    if [ $userOption -lt $optionNumbers ] && [ $userOption -gt 0 ]; then
      chmod 777 $repoFolder
      local selectedRecover=$(sed "${userOption}q;d" "$configFolder/"removedRepo.txt"")
      IFS='~' read -ra recoveryArray <<< "$selectedRecover"
      local recoveryName="${recoveryArray[2]}"
      echo "Recovering: $recoveryName"
      local recoveryDir=$(sed -e 's/^"//' -e 's/"$//' <<<"${recoveryArray[0]}")
      #Copies repo
      chmod -R 777 $recoveryDir
      mv "$recoveryDir/$recoveryName/" "$repoFolder/$recoveryName/"
      chmod -R 551 "$repoFolder/$recoveryName"
      # remove instance for txt holding backed up repos
      sed -i.bak "${userOption}d" "$configFolder/"removedRepo.txt""
      rm -rf "$(pwd)/$configFolder/"removedRepo.txt.bak""
      chmod 551 $repoFolder
      # Adds instance back to txt file holding active repos
      echo "\"$baseFolder/$repoFolder/$recoveryName/\"~$recoveryName" >> "$configFolder/"repos.txt""
      # Removes backup repo folder, that has time stamp
      rm -rf $recoveryDir
    else
      echo"Invalid Choice"
    fi
  else
    echo "No Repository can currently be recovered!"
    echo "Note: backups are removed after one week"
  fi
}


listCheckoutfiles(){
  # Places ls output for file
  echo -e "$(ls -lR)" >> "$baseFolder/$configFolder/.temptxt.txt"
  echo "Files currently checked out"
  # reads file line by line
  while IFS= read -r line
  do
    line="${line//+([  ])/ }" # turns double spaces to single spaces
    IFS=' ' read -ra filterLine <<< "$line"
    # Checks if the file is assigned to the user and if they have write perms
    if [ "${filterLine[0]}" = "-rwxrwxrwx" ] || [ "${filterLine[0]}" = "-rwxrwxrwx@" ]; then
      echo "${filterLine[8]} : ${filterLine[2]}"
    fi
  done <"$baseFolder/$configFolder/.temptxt.txt"
  # Remove txt file
  rm -rf "$baseFolder/$configFolder/.temptxt.txt"
}

editFile(){
  if [ "$(ls $selectedRepo)" ]; then
    echo "What file would you like to edit"


    read file
       chmod 777 "$selectedRepo/.backup"
    cp $file "$selectedRepo/.backup/$(date +%s)~$file"
    cd .backup
    chmod 555 ".backup"
    cd ..
    chmod 555 "$selectedRepo/.backup"
    if [ -f $file ] ;then
  	   chmod 777 "$file" # Only changes user i can't seem  to change the other people permissions UGO doesn't seem to work
  	   vi $file ## or allow user to type stuff cat show and then sed "text"
       chmod 555 "$file" ## Change it back to read only chmod 222 or the 0ther ones
       read -p  "Please enter your commit message " message
       chmod 777 ".log.txt"
       echo "$(date +%s)~$file~$message"  >> ".log.txt"
       chmod 555 ".log.txt "
    else
     	  echo "The file '$file' in not found"
        echo "Sending back to menu"
    fi
  else
    echo "empty repo"
  fi
}

createFile(){
  read file
  if [ -f $file ] ; then
    echo "file already exists"
  else
    chmod 777 ".log.txt"
    echo "$(date +%s)~$file~created file"  >> ".log.txt"
    chmod 555 ".log.txt "
    chmod 777 $selectedRepo
    touch $file
    chmod 555 $selectedRepo
    chmod 555 "$selectedRepo/$file"
  fi
}

deleteFile(){
      ls
      read file

      if [ -f $file ] ;then
        chmod 777 "$selectedRepo/.backup"
     cp $file "$selectedRepo/.backup/$(date +%s)~$file"
     cd .backup
     chmod 555 ".backup"
     cd ..


     chmod 555 "$selectedRepo/.backup"
            rm $file
            echo "You have deleted the file '$file'"
            chmod 777 ".log.txt"
            echo "$(date +%s)~$file~Deleted file"  >> ".log.txt"
            chmod 555 ".log.txt "
            chmod -R 555 $selectedRepo
      else
             echo "The file '$file' in not found"
             echo "Sending back to menu"
      fi
      #loop menu
}

displayLog(){
  if [ -f ".log.txt" ]; then
    clear
    while IFS= read -r line
    do
      IFS='~' read -ra logtxt <<< "$line"
      echo "$(date -r ${logtxt[0]}) | ${logtxt[1]} | ${logtxt[2]}"
    done <".log.txt"
  fi
}

  recoverFile(){
  clear
  local check=false
  local split
    echo "Enter number of the file you want to recover"
    echo ""
unset options i
  while IFS= read -r -d $'\0' fileName; do
        options[i++]="$(basename  $fileName)"
        done < <(find "$selectedRepo/.backup/" -type f -name "*.txt" -print0 )
  select opt in "${options[@]}" "Exit"; do

      case $opt in
      *txt)
      echo "You have selected option this $opt file"
while [ $check == false ]; do
  read -p "What would you like to rename your file to " newFile
      if [ -f $selectedRepo/$newFile ] ; then
        echo "file already exists"
      else
  chmod 777 "$selectedRepo"
    cp "$selectedRepo/.backup/$opt" "$newFile.txt"
   chmod 555 "$selectedRepo"
  check=true
 fi
done
break
    ;;
    "Exit")
      echo "Exit backup"
      break
      ;;
    *)
      echo "Please select a valid number"
      ;;
  esac
done
}


repoFunctionMenu(){
if [ $noRepo == false ];then
  while true
  do
  echo "Option 1) Edit a file"
  echo "Option 2) Create a new file in the repository"
  echo "Option 3) Delete a file"
  echo "Option 4) List files checked out to user"
  echo "Option 5) Display Log Files"
  echo "Option 6) Recover Files"
  echo "Option 0) Quit"
  read -p "Please enter an option: " choice
  case $choice in
    1) echo "You entered one, edit a file."
      editFile
      ;;
    2) echo "You entered two, what would you like to call the file?"
      createFile
      ;;
    3) echo "You entered three, which file would you like to delete?"
      deleteFile
      ;;
    4 ) echo "You entered four, Displaying files checkout to user"
      listCheckoutfiles
    ;;
    5 ) echo "You entered five, Display Log file"
      displayLog
    ;;
    6 ) echo "You entered six, Recover file"
      recoverFile
    ;;
    0 ) echo "Goodbye!"
    cd $baseFolder
    break
    ;;
    *) echo "You entetered a number outside of the available options."
  esac
  done
else
  echo "No Repository Selected"
  cd $baseFolder
fi
}

# Menu
autobBackupRemoval
while true
do
echo "Option 1) Open a file repository"
echo "Option 2) Create a new file repository"
echo "Option 3) Delete a repository"
echo "Option 4) Recover Deleted Repository"
echo "Option 0) Quit"
read -p "Please enter an option: " option
case $option in
  1 ) echo "You entered one, open a file repository"
  ls

  ##openRepo
##  cd "$selectedRepo"
##  echo $(pwd)
##  repoFunctionMenu
    recoverFile
  ;;
  2 ) echo "You entered two, create a new file repository:"
    makeRepo
  ;;
  3 ) echo "You entered Three, Delete a file Repository"
    deleteRepo
  ;;
  4 ) echo "You entered Four, Recover a Repository"
    recoverRepository
  ;;
  0 ) echo "Goodbye!"
  break
  ;;
  *) echo "You entetered a number outside of the available options."
esac
done
