#!/bin/bash

# Backup default config.json file at first boot
if [ ! -f /opt/mattermost/config/config.json.orig ]; then
  cp -a /opt/mattermost/config/config.json /opt/mattermost/config/config.json.orig
fi

if [[ ! -z "$DRIVER_NAME" && ! -z "$DATA_SOURCE" ]]; then
    sed -e 's#"DriverName": "mysql"#"DriverName": "'"$DRIVER_NAME"'"#' \
        -e 's#"DataSource": "mmuser:mostest@tcp(mysql:3306)/mattermost_test?charset=utf8mb4,utf8"#"DataSource": "'"$DATA_SOURCE"'"#' \
        /opt/mattermost/config/config.json.orig > /opt/mattermost/config/config.json
    grep DataSource /opt/mattermost/config/config.json
fi

cd /opt/mattermost/bin/
exec /opt/mattermost/bin/platform
