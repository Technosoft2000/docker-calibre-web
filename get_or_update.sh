#!/bin/bash

# get or update all parts for the APP

# download the latest version of the Calibre Web
# see at https://github.com/janeczku/calibre-web/
source /init/checkout.sh "$APP_NAME" "$APP_BRANCH" "$APP_REPO" "$APP_HOME/app"

# check if a config directory should be used
if [ "$USE_CONFIG_DIR" = "true" ]; then
    CONFIG_DIR="$APP_HOME/config"
    echo "[INFO] Config directory option is ACTIVATED"
    echo "> due this the directory $CONFIG_DIR will be used to store the configuration"
    # check if configuration directory exists, otherwise create it
    if [ ! -d "$CONFIG_DIR" ]; then
        echo "[INFO] Creating the configuration directory: $CONFIG_DIR"
        mkdir -p $CONFIG_DIR
    fi
    echo "[INFO] Change the ownership of $CONFIG_DIR (including subfolders) to $PUSER:$PGROUP"
    chown -R $PUSER:$PGROUP $CONFIG_DIR
else 
    CONFIG_DIR=$CALIBRE_PATH
    echo "[INFO] Config directory option is DEACTIVATED" 
    echo "> due this the Calibre books directory $CONFIG_DIR will be used to store the configuration"
fi

# check the permissions of the config directory
echo "[INFO] Checking permissions of the config directory: $CONFIG_DIR"

echo "> Output is: $(stat -L -c "%a %G %g %U %u" $CONFIG_DIR)"
INFO=( $(stat -L -c "%a %G %g %U %u" $CONFIG_DIR) )

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
    echo "> Everyone has write access at $CONFIG_DIR"
elif ((($PERM & 0020) != 0 )); then
    # Some group has write access.
    # Is user in that group?
    gs=( $(groups $PUSER) )
    for g in "${gs[@]}"; do
        echo "> Check if the group $g has write access at $CONFIG_DIR" 
        if [[ $GROUP == $g ]]; then
            ACCESS="yes"
            echo "> The group $g has write access at $CONFIG_DIR"
            break
        else
            echo "> The group $g has no write access at $CONFIG_DIR"
        fi
    done
elif ((($PERM & 0200) != 0 )); then
    # The owner has write access.
    # Does the user own the file?
    if [[ $PUSER == $OWNER ]] || [[ $PUID == $OWNER_UID ]]; then
        ACCESS="yes"
        echo "> The user $PUSER:$PUID is the owner and has write access at $CONFIG_DIR"
    else
        echo "> The user $PUSER:$PUID is not the owner has no write access at $CONFIG_DIR"
    fi
fi

if [[ $ACCESS == "yes" ]]; then
    # create symlinks for the app databases (configuration)
    echo "[INFO] 'app.db' and 'gdrive.db' will be linked into $CONFIG_DIR"
    
    APPDB_SRC="$CONFIG_DIR/app.db"
    APPDB_LINK="$APP_HOME/app/app.db"
    if [[ -L "$APPDB_LINK" &&  -e "$APPDB_LINK" ]]; then
        echo "> 'app.db' link $APPDB_LINK exists already and won't be recreated"
    else
        echo "> create 'app.db' link $APPDB_LINK assigned to source $APPDB_SRC"
        ln -s $APPDB_SRC $APPDB_LINK
        echo "> change the ownership of $APPDB_LINK to $PUSER:$PGROUP"
        chown -h $PUSER:$PGROUP $APPDB_LINK
    fi
    
    GDRIVEDB_SRC="$CONFIG_DIR/gdrive.db"
    GDRIVEDB_LINK="$APP_HOME/app/gdrive.db"
    if [[ -L "$GDRIVEDB_LINK" && -e "$GDRIVEDB_LINK" ]]; then
        echo "> 'gdrive.db' link $GDRIVEDB_LINK exists already and won't be recreated"
    else
        echo "> create 'gdrive.db' link $GDRIVEDB_LINK assigned to source $GDRIVEDB_SRC"
        ln -s $GDRIVEDB_SRC $GDRIVEDB_LINK
        echo "> change the ownership of $GDRIVEDB_LINK to $PUSER:$PGROUP"
        chown -h $PUSER:$PGROUP $GDRIVEDB_LINK
    fi

else
    echo "[WARNING] No write access at $CONFIG_DIR - app.db and gdrive.db wont be linked into $CONFIG_DIR"
fi

# check the permissions of the books directory
echo "[INFO] Checking permissions of the books directory: $CALIBRE_PATH"

echo "> Output is: $(stat -L -c "%a %G %g %U %u" $CALIBRE_PATH)"
INFO=( $(stat -L -c "%a %G %g %U %u" $CALIBRE_PATH) )

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
    echo "> Everyone has write access at $CALIBRE_PATH"
elif ((($PERM & 0020) != 0 )); then
    # Some group has write access.
    # Is user in that group?
    gs=( $(groups $PUSER) )
    for g in "${gs[@]}"; do
        echo "> Check if the group $g has write access at $CALIBRE_PATH" 
        if [[ $GROUP == $g ]]; then
            ACCESS="yes"
            echo "> The group $g has write access at $CALIBRE_PATH"
            break
        else
            echo "> The group $g has no write access at $CALIBRE_PATH"
        fi
    done
elif ((($PERM & 0200) != 0 )); then
    # The owner has write access.
    # Does the user own the file?
    if [[ $PUSER == $OWNER ]] || [[ $PUID == $OWNER_UID ]]; then
        ACCESS="yes"
        echo "> The user $PUSER:$PUID is the owner and has write access at $CALIBRE_PATH"
    else
        echo "> The user $PUSER:$PUID is not the owner has no write access at $CALIBRE_PATH"
    fi
fi

if [[ $ACCESS == "yes" ]]; then
    # check if a Calibre library exists already, otherwise copy initial files
    if [ ! -f $CALIBRE_PATH/metadata.db ]; then
        echo "[WARNING] The mapped volume for $CALIBRE_PATH doesn't contain a Calibre database file 'metadata.db'"
        echo "> Due this an inital Calibre database file 'metadata.db' and 'metadata_db_prefs_backup.json' will be copied to $CALIBRE_PATH"
        cp /init/calibre-init/* $CALIBRE_PATH
        chown $PUSER:$PGROUP $CALIBRE_PATH/metadata.db
        chown $PUSER:$PGROUP $CALIBRE_PATH/metadata_db_prefs_backup.json
    else
        echo "[INFO] The mapped volume for $CALIBRE_PATH contains a Calibre database file 'metadata.db' which will be used"
    fi
else
    echo "[WARNING] No write access at $CALIBRE_PATH - new 'metadata.db' and books can't be stored at this directory"
    echo "> Please check and modify the permissions of the directory"
fi

# create the kindlegen directory if it doesn't exist
if [[ ! -d $APP_HOME/kindlegen ]]; then
    echo "[INFO] Creating the kindlegen directory: $APP_HOME/kindlegen"
    mkdir -p $APP_HOME/kindlegen
    echo "[INFO] Change the ownership of $APP_HOME/kindlegen (including subfolders) to $PUSER:$PGROUP"
    chown -R $PUSER:$PGROUP $APP_HOME/kindlegen
else
    echo "[INFO] The kindlegen directory exist already and will be used: $APP_HOME/kindlegen"
fi

# download and install kindlegen (Amazon Kindle Generator)
if [[ ! -f $APP_HOME/kindlegen/kindlegen ]]; then
    echo "[INFO] Downloading kindlegen from $AMAZON_KG_URL into directory: $APP_HOME/kindlegen/$AMAZON_KG_TAR"
    wget $AMAZON_KG_URL -P $APP_HOME/kindlegen
    echo "[INFO] Extracting $AMAZON_KG_TAR into directory: $APP_HOME/kindlegen"
    tar -xzf $APP_HOME/kindlegen/$AMAZON_KG_TAR -C $APP_HOME/kindlegen
    echo "[INFO] Change the ownership of $APP_HOME/kindlegen (including subfolders) to $PUSER:$PGROUP"
    chown -R $PUSER:$PGROUP $APP_HOME/kindlegen
else
    echo "[INFO] Kindlegen application exists already in directory: $APP_HOME/kindlegen"
fi

# create symlink for kindlegen (Amazon Kindle Generator)
KINDLEGEN_DIR="$APP_HOME/kindlegen"
VENDOR_DIR="$APP_HOME/app/vendor"
echo "[INFO] kindlegen (Amazon Kindle Generator) will be linked into $VENDOR_DIR"
KINDLEGEN_SRC="$KINDLEGEN_DIR/kindlegen"
KINDLEGEN_LINK="$VENDOR_DIR/kindlegen"
if [[ -L "$KINDLEGEN_LINK" &&  -e "$KINDLEGEN_LINK" ]]; then
    echo "> kindlegen link $KINDLEGEN_LINK exists already and won't be recreated"
else
    # check if vendor directory exists, otherwise create it
    if [ ! -d "$VENDOR_DIR" ]; then
        echo "[INFO] Creating the vendor directory: $VENDOR_DIR"
        mkdir -p $VENDOR_DIR
        echo "[INFO] Change the ownership of $VENDOR_DIR (including subfolders) to $PUSER:$PGROUP"
        chown $PUSER:$PGROUP $VENDOR_DIR
    fi
    echo "> create kindlegen link $KINDLEGEN_LINK assigned to source $KINDLEGEN_SRC"
    ln -s $KINDLEGEN_SRC $KINDLEGEN_LINK
    echo "> change the ownership of $KINDLEGEN_LINK to $PUSER:$PGROUP"
    chown -h $PUSER:$PGROUP $KINDLEGEN_LINK
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
