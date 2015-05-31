#!/usr/bin/env bash

#check if new release exists
if [ -e $2/releases/$1 ]; then
    echo "Generating symlinks to shared resource for release $1"
    #Magento
    cd $2/shared
    find . -follow -iname "*" -print0 | while IFS= read -r -d $'\0' file; do
        #checks if shared file/directory doesn't exists in new release folder
        if ! [ -e $2/releases/$1/source/$file ]; then
            ln -s $2/shared/$file $2/releases/$1/source/$file
            echo "$file symlink created"
	    fi
    done

    echo "Pointing current folder to release $1"
    rm -f $2/current
    ln -s $2/releases/$1 $2/current

    echo "Restarting PHP service"
    sudo service php54-php-fpm restart

    echo "Removing session files"
    rm -rf /webapps/www/sites/current/source/var/session/*

    echo "Restarting Varnish service"
    sudo service varnish restart

    echo "Removing all builds"
    cd $2/releases/ && (ls -t|head -n 5;ls)|sort|uniq -u|xargs rm -rf
else
    echo "Error: Couldn't create $1 release"
fi
