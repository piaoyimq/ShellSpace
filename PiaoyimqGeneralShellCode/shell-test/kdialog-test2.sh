#!/bin/bash
set -x
#// Note: create variables to hold paths to all the sites
PERSONALSITE='/home/www/mypersonalsite/'
BUSINESSSITE='/home/www/mybusinesssite/'
HOBBYSITE='/home/www/myhobbysite/'

#// Note: create variable to hold path to the destination
DESTINATION='/home/user/backup'

#// Note: display a dialog asking the user to select which sites to back-up
CHOICES=$(kdialog --checklist "Select sites to back-up:" 1 "Personal site" off 2 "Business Site" off 3 "Hobby site" off)

#// Note: log a success/failure message for each of the choices returned from dialog
for each in $CHOICES
do
    case {
        1)
            cd $PERSONALSITE
            drush ard --destination=$DESTINATION/mypersonalsite.tar.gz
            if [$?=="0"]
            then
                RESULTS += "Personal site backup: Succeeded\n"
            else
                RESULTS += "Personal site backup: Failed\n"
            fi
            ;;
        2)
            cd $BUSINESSSITE
            drush ard --destination=$DESTINATION/mybusinesssite.tar.gz
            if [$?=="0"]
            then
                RESULTS += "Business site backup: Succeeded\n"
            else
                RESULTS += "Business site backup: Failed\n"
            fi
            ;;
        3)
            cd $HOBBYSITE
            drush ard --destination=$DESTINATION/myhobbysite.tar.gz
            if [$?=="0"]
            then
                RESULTS += "Hobby site backup: Succeeded\n"
            else
                RESULTS += "Hobby site backup: Failed\n"
            fi
            ;;
    esac

#// NOTE: display a dialog with the results of all the backup operations.
kdialog --msgbox $RESULTS