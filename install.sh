#!/usr/bin/env bash
homeDir=$(eval echo ~$USER)
version=0.0.1
relativePath=$(pwd)
deployableLink="https://raw.githubusercontent.com/vlee489/2A-CVS-Script/deployabl/main.sh"

echo "$homeDir"

echo "You are about to install CVS Repository Manager"
read -p "yes / no: " confirm
if [ $confirm == "yes" ] || [ $confirm == "y" ]; then
  if [ -e "$relativePath/cvs.sh" ]; then
    echo "Making Dirs and files needed for CVS Repository Manager to function"
    mkdir "$homeDir/.CVSConfigs"
    mkdir "$homeDir/.CVSConfigs/.repoRecovery"
    mkdir "$homeDir/Repositories"
    touch "$homeDir/.CVSConfigs/repos.txt"
    touch "$homeDir/.CVSConfigs/removedRepo.txt"
    echo "$version" >> "$homeDir/.CVSConfigs/VERSION"
    echo "Moving main CVS file"
    mv "$relativePath/cvs.sh" "$homeDir/cvs.sh"
    chmod 555 "$homeDir/cvs.sh"
  else
    echo "Unable to find cvs.sh file to install!"
  fi
else
  echo "Install Aborted"
fi
