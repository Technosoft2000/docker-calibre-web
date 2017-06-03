#!/bin/bash

# get or update all parts for the APP

# download the latest version of the Calibre Web
# see at https://github.com/janeczku/calibre-web/
source /init/checkout.sh "$APP_NAME" "$APP_BRANCH" "$APP_REPO" "$APP_HOME/app"

# create symlink for kindlegen (Amazon Kindle Generator)
ln -s $APP_HOME/kindlegen/kindlegen $APP_HOME/app/vendor/kindlegen

# create symlinks for the app databases
# Use -L to get information about the target of a symlink,
# not the link itself, as pointed out in the comments
DIR=/books
INFO=( $(stat -L -c "%a %G %U" $DIR) )
PERM=${INFO[0]}
GROUP=${INFO[1]}
OWNER=${INFO[2]}

ACCESS="no"
if ((($PERM & 0002) != 0 )); then
    # Everyone has write access
    ACCESS="yes"
    echo "[INFO] Everyone has write access at $DIR"
elif ((($PERM & 0020) != 0 )); then
    # Some group has write access.
    # Is user in that group?
    gs=( $(groups $USER) )
    for g in "${gs[@]}"; do
        echo "[INFO] Check if the group $g has write access at $DIR" 
        if [[ $GROUP == $g ]]; then
            ACCESS="yes"
            echo "[INFO] The group $g has write access at $DIR"
            break
        fi
    done
elif ((($PERM & 0200) != 0 )); then 
    # The owner has write access.
    # Does the user own the file?
    if [[ $USER == $OWNER ]]; then 
        ACCESS="yes"
        echo "[INFO] The user is the owner and has write access at $DIR"
    fi
fi

if [[ $ACCESS == "yes" ]]; then
    echo "[INFO] app.db and gdrive.db will be linked into /books"
    ln -s /books/app.db "$APP_HOME/app/app.db"
    ln -s /books/gdrive.db "$APP_HOME/app/gdrive.db"
else
    echo "[WARNING] no write access at /books - app.db and gdrive.db wont be linked into /books"
fi

# check if the specified books volume is correct
if [ ! -f $CALIBRE_PATH/metadata.db ]; then
    echo "[ERROR] The mapped volume for $CALIBRE_PATH doesn't contain a Calibre database file 'metadata.db'"
    echo "> Please fix the volume mapping before you retry to start the container again"
    echo "> Stopping the container with errorlevel 1"
    exit 1
fi
