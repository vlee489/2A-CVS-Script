#!/usr/bin/env bash
repoFolder="Repositories"
configFolder=".CVSConfigs"
selectedRepo=""
selectedRepoName=""
noRepo=false



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
      echo "\"$recoveryDir/$recoveryName/\"~$recoveryName" >> "$configFolder/"repos.txt""
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
  echo -e "$(ls -lR)" >> "$configFolder/.temptxt.txt"
  echo "Files currently checkout to you"
  # reads file line by line
  while IFS= read -r line
  do
    line="${line//+([  ])/ }" # turns double spaces to single spaces
    IFS=' ' read -ra filterLine <<< "$line"
    # Checks if the file is assigned to the user and if they have write perms
    if [ "${filterLine[0]}" = "-rwxrwxrwx" ] && [ "${filterLine[2]}" = "$USER" ]; then
      echo "${filterLine[8]} : ${filterLine[2]}"
    fi
  done <"$configFolder/.temptxt.txt"
  # Remove txt file
  rm -rf "$configFolder/.temptxt.txt"
}

listCheckoutfiles
