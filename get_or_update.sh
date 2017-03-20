#!/bin/bash

# get or update all parts for the APP

# download the latest version of the Calibre Web
# see at https://github.com/janeczku/calibre-web/
source /init/checkout.sh "$APP_NAME" "$APP_BRANCH" "$APP_REPO" "$APP_HOME/app"

# create a symlink for the app database
ln -s /books/app.db "$APP_HOME/app/app.db"

# check if the specified books volume is correct
if [ ! -f $CALIBRE_PATH/metadata.db ]; then
    echo "[ERROR] The mapped volume for $CALIBRE_PATH doesn't contain a Calibre database file 'metadata.db'"
    echo "> Please fix the volume mapping before you retry to start the container again"
    echo "> Stopping the container with errorlevel 1"
    exit 1
fi
