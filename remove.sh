#!/usr/bin/env bash
homeDir=$(eval echo ~$USER)

clear
echo "You are about to REMOVE CVS Repository Manager"
echo "This will also delete all your repository"
read -p "yes / no: " confirm
if [ $confirm == "yes" ] || [ $confirm == "y" ]; then
  chmod -R 777 "$homeDir/.CVSConfigs"
  chmod -R 777 "$homeDir/Repositories"
  rm -rf "$homeDir/.CVSConfigs"
  rm -rf "$homeDir/Repositories"
  rm -f "$homeDir/cvs.sh"
  echo "Files removed"
else
  echo "Aborting"
fi
