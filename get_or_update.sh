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
echo "[INFO] Checking permissions of $DIR"

echo "> Output is: $(stat -L -c "%a %G %U" $DIR)"
INFO=( $(stat -L -c "%a %G %U" $DIR) )

PERM=${INFO[0]}
echo "> Permissions: $PERM"

GROUP=${INFO[1]}
echo "> Assigned group: $GROUP"

OWNER=${INFO[2]}
echo "> Assigned owner: $OWNER"

# get the number of digits of PERM; could be 3 or 4
PERMLEN=${#PERM}
if [[ $PERMLEN == 3 ]]; then
    # add a precending zero because otherwise the permission checks doesn't work
    PERM="0$PERM"
    echo "> Using permissons for checks: $PERM"
fi

ACCESS="no"
if ((($PERM & 0002) != 0 )); then
    # Everyone has write access
    ACCESS="yes"
    echo "> Everyone has write access at $DIR"
elif ((($PERM & 0020) != 0 )); then
    # Some group has write access.
    # Is user in that group?
    gs=( $(groups $PUSER) )
    for g in "${gs[@]}"; do
        echo "> Check if the group $g has write access at $DIR" 
        if [[ $GROUP == $g ]]; then
            ACCESS="yes"
            echo "> The group $g has write access at $DIR"
            break
        fi
    done
elif ((($PERM & 0200) != 0 )); then 
    # The owner has write access.
    # Does the user own the file?
    if [[ $PUSER == $OWNER ]]; then 
        ACCESS="yes"
        echo "> The user is the owner and has write access at $DIR"
    fi
fi

if [[ $ACCESS == "yes" ]]; then
    echo "[INFO] app.db and gdrive.db will be linked into $DIR"
    ln -s $DIR/app.db "$APP_HOME/app/app.db"
    ln -s $DIR/gdrive.db "$APP_HOME/app/gdrive.db"
else
    echo "[WARNING] No write access at $DIR - app.db and gdrive.db wont be linked into $DIR"
fi

# check if the specified books volume is correct
if [ ! -f $CALIBRE_PATH/metadata.db ]; then
    echo "[ERROR] The mapped volume for $CALIBRE_PATH doesn't contain a Calibre database file 'metadata.db'"
    echo "> Please fix the volume mapping before you retry to start the container again"
    echo "> Stopping the container with errorlevel 1"
    exit 1
fi

# check if a /tmp directory is available, if not create one
# the /tmp directory is needed by calibre-web/kindlegen to convert books to mobi format
# and maybe for other tasks too
TEMP=/tmp
if [ ! -d "$TEMP" ]; then
   echo "[INFO] Creating directory for temporary directories and files: $TEMP"
   mkdir $TEMP
   echo "[INFO] Change the ownership of $TEMP (including subfolders) to $PUSER:$PGROUP"
   chown $PUSER:$PGROUP -R $TEMP
fi
