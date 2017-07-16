#!/bin/bash

set -e

# support passing password as docker secret
if [[ "$DB_PASSWORD_FILE" ]] ; then
	DB_PASSWORD=$(cat $DB_PASSWORD_FILE)
	export DB_PASSWORD
fi

# wait for mysql port
echo "Waiting for MySQL connection..."
docker/wait-for-it/wait-for-it.sh -t 30 -s "$DB_HOST:$DB_PORT"

echo "Launching harmony-api via harmony.main.harmony-api"
HARMONY_RELEASE=$(cat RELEASE)
export HARMONY_RELEASE
exec java $HARMONY_JAVA_OPTS -cp target/sharetribe-harmony.jar clojure.main -m harmony.main.harmony-api
