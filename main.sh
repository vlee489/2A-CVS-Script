#!/usr/bin/env bash

//Menu
PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "1) Open a File Repository")
            echo "Option 1 selected, open a file repository"
            break
            ;;
        "2) Create a New File Repository")
            echo "Option 2 selected, create a new file repository"
            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
