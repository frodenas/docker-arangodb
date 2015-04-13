#!/bin/bash
USER=${ARANGODB_USERNAME:-arango}
PASS=${ARANGODB_PASSWORD:-$(pwgen -s -1 16)}
DB=${ARANGODB_DBNAME:-}

# Start ArangoDB service
/usr/sbin/arangod --configuration /etc/arangodb/arangod.conf --pid-file /var/run/arangodb/arangod.pid &
while ! nc -vz localhost 8529; do sleep 1; done

# Create User
echo "Creating user: \"$USER\"..."
echo "require(\"org/arangodb/users\").save(\"$USER\", \"$PASS\")" | /usr/bin/arangosh

# Create Database
if [ ! -z "$DB" ]; then
    echo "Creating database: \"$DB\"..."
    echo "db._createDatabase(\"$DB\"); db._useDatabase(\"$DB\"); require(\"org/arangodb/users\").save(\"$USER\", \"$PASS\")" | /usr/bin/arangosh
fi

# Stop ArangoDB service
pid=$(cat /var/run/arangodb/arangod.pid)
kill $pid
while [ -e /proc/$pid ]; do sleep 1; done

echo "========================================================================"
echo "ArangoDB User: \"$USER\""
echo "ArangoDB Password: \"$PASS\""
if [ ! -z "$DB" ]; then
    echo "ArangoDB Database: \"$DB\""
fi
echo "========================================================================"

rm -f /.firstrun
