#!/bin/bash

# show the info text
cat $CW_HOME/info.txt

# run the default config script
source $CW_HOME/config.sh

# chown the Calibre Web directory by the new user
echo "[INFO] Change the ownership of $CW_HOME (including subfolders) to $PUSER:$PGROUP"
chown $PUSER:$PGROUP -R $CW_HOME

# download the latest version of the Calibre Web release
# see at https://github.com/janeczku/calibre-web/
echo "[INFO] Checkout the latest Calibre Web version ..."
[[ ! -d $CW_HOME/app/.git ]] && gosu $PUSER:$PGROUP bash -c "git clone -b $CW_BRANCH $CW_REPO $CW_HOME/app"

# opt out for autoupdates using env variable
if [ -z "$ADVANCED_DISABLEUPDATES" ]; then
    echo "[INFO] Autoupdate is active, try to pull the latest sources ..."
    # update the application
    cd $CW_HOME/app/ && gosu $PUSER:$PGROUP bash -c "git pull"
fi

# check if Amazon KindleGen is linked
if [ ! -f $CW_HOME/app/vendor/kindlegen ]; then
    echo "[INFO] Create symlink to Amazon KindleGen tool"
    ln -s $CW_HOME/app/kindlegen/kindlegen $CW_HOME/app/vendor/kindlegen
fi

# check if config.ini exist
if [ ! -f $CW_HOME/app/config.ini ]; then
    echo "[INFO] Initializing the configuration file for the first start ..."
    cp $CW_HOME/app/config.ini.example $CW_HOME/app/config.ini
    # set DB_ROOT value
    echo "> Set configuration key DB_ROOT = $SYNO_HOME/books"
    sed -i 's/^DB_ROOT =/DB_ROOT = $SYNO_HOME\/books/g' $CW_HOME/app/config.ini
    # change file rights
    echo "> Change the owenership of $CW_HOME/app/config.ini to $PUSER:$PGROUP"
    chown $PUSER:$PGROUP $CW_HOME/app/config.ini
    chmod ug+wr $CW_HOME/app/config.ini
fi

# check if the specified books volume is correct
if [ ! -f $SYNO_HOME/books/metadata.db ]; then
    echo "[ERROR] The mapped volume for $SYNO_HOME/books doesn't contain a Calibre database file 'metadata.db'"
    echo "> Please fix the volume mapping before you retry to start the container again"
    echo "> Stopping the container with errorlevel 1"
    exit 1
fi

# run Calibre Web
echo "[INFO] Launching Calibre Web ..."
gosu $PUSER:$PGROUP bash -c "/usr/bin/python $CW_HOME/app/cps.py"
