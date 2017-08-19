#!/bin/bash

# get or update all parts for the APP

# download the latest version of the Calibre Web
# see at https://github.com/janeczku/calibre-web/
source /init/checkout.sh "$APP_NAME" "$APP_BRANCH" "$APP_REPO" "$APP_HOME/app"

# create symlink for kindlegen (Amazon Kindle Generator)
echo "[INFO] kindlegen (Amazon Kindle Generator) will be linked into $APP_HOME/app/vendor"
KINDLEGEN_SRC="$APP_HOME/kindlegen/kindlegen"
KINDLEGEN_LINK="$APP_HOME/app/vendor/kindlegen"
if [[ -L "$KINDLEGEN_LINK" &&  -e "$KINDLEGEN_LINK" ]]; then
	echo "> kindlegen link $KINDLEGEN_LINK exists already and won't be recreated"
else
	echo "> create kindlegen link $KINDLEGEN_LINK assigned to source $KINDLEGEN_SRC"
	ln -s $KINDLEGEN_SRC $KINDLEGEN_LINK
fi

# create symlinks for the app databases
# Use -L to get information about the target of a symlink,
# not the link itself, as pointed out in the comments
DIR=/books
echo "[INFO] Checking permissions of $DIR"

echo "> Output is: $(stat -L -c "%a %G %g %U %u" $DIR)"
INFO=( $(stat -L -c "%a %G %g %U %u" $DIR) )

PERM=${INFO[0]}
echo "> Permissions: $PERM"

GROUP=${INFO[1]}
echo "> Assigned group: $GROUP"

GROUP_GID=${INFO[2]}
echo "> Assigned group ID: $GROUP_GID"

OWNER=${INFO[3]}
echo "> Assigned owner: $OWNER"

OWNER_UID=${INFO[4]}
echo "> Assigned owner ID: $OWNER_UID"

# get the number of digits of PERM; could be 3 or 4
PERMLEN=${#PERM}
if [[ $PERMLEN == 3 ]]; then
    # add a precending zero because otherwise the permission checks doesn't work
    PERM="0$PERM"
fi
echo "> Using permissions for checks: $PERM"

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
        else
            echo "> The group $g has no write access at $DIR"
        fi
    done
elif ((($PERM & 0200) != 0 )); then
    # The owner has write access.
    # Does the user own the file?
    if [[ $PUSER == $OWNER ]] || [[ $PUID == $OWNER_UID ]]; then
        ACCESS="yes"
        echo "> The user $PUSER:$PUID is the owner and has write access at $DIR"
	else
	    echo "> The user $PUSER:$PUID is not the owner has no write access at $DIR"
    fi
fi

if [[ $ACCESS == "yes" ]]; then
    echo "[INFO] app.db and gdrive.db will be linked into $DIR"
	
	APPDB_SRC="$DIR/app.db"
	APPDB_LINK="$APP_HOME/app/app.db"
	if [[ -L "$APPDB_LINK" &&  -e "$APPDB_LINK" ]]; then
        echo "> app.db link $APPDB_LINK exists already and won't be recreated"
	else
	    echo "> create app.db link $APPDB_LINK assigned to source $APPDB_SRC"
	    ln -s $APPDB_SRC $APPDB_LINK
	fi
    
	GDRIVEDB_SRC="$DIR/gdrive.db"
	GDRIVEDB_LINK="$APP_HOME/app/gdrive.db"
    if [[ -L "$GDRIVEDB_LINK" && -e "$GDRIVEDB_LINK" ]]; then
        echo "> gdrive.db link $GDRIVEDB_LINK exists already and won't be recreated"
	else
		echo "> create gdrive.db link $GDRIVEDB_LINK assigned to source $GDRIVEDB_SRC"
		ln -s $GDRIVEDB_SRC $GDRIVEDB_LINK
	fi

    # check if a Calibre library exists already, otherwise copy initial files
    if [ ! -f $CALIBRE_PATH/metadata.db ]; then
        echo "[WARNING] The mapped volume for $CALIBRE_PATH doesn't contain a Calibre database file 'metadata.db'"
        echo "> Due this an inital Calibre database file 'metadata.db' and 'metadata_db_prefs_backup.json' will be copied to $CALIBRE_PATH"
        cp /init/calibre-init/* $CALIBRE_PATH
        chown $PUSER:$PGROUP $CALIBRE_PATH/metadata.db
        chown $PUSER:$PGROUP $CALIBRE_PATH/metadata_db_prefs_backup.json
    fi

else
    echo "[WARNING] No write access at $DIR - app.db and gdrive.db wont be linked into $DIR"
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
