#!/bin/bash

# Initialize directories
mkdir -p /data/databases
mkdir -p /data/apps
mkdir -p /data/cluster

# Initialize first run
if [[ -e /.firstrun ]]; then
    /scripts/first_run.sh
fi

# Start ArangoDB
echo "Starting ArangoDB..."
/usr/sbin/arangod --configuration /etc/arangodb/arangod.conf
