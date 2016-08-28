#!/bin/bash

#Get the current active timezone.
TZ=`date | awk -F' ' '{print \$5}'`
echo "[INFO] Current active timezone is $TZ"

#Check if the timezone should be changed 
if [ "$SET_CONTAINER_TIMEZONE" = "true" ]; then
    #Check if the current active timezone is already the target timezone 
    if [ "$CONTAINER_TIMEZONE" != "$TZ" ]; then
        ln -sf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
        echo $CONTAINER_TIMEZONE > /etc/timezone && date
        echo "[INFO] Container timezone is changed to: $CONTAINER_TIMEZONE"
    else
        echo "[INFO] The defined timezone is already active."
    fi
fi
