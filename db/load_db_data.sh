#!/bin/sh

set -e

export DB_DUMP_LOCATION=/tmp/psql_data/db1.bz2

echo "*** CREATING DATABASE ***"

# create default database
"${psql[@]}" <<- 'EOSQL'
CREATE ROLE etoolusr WITH superuser login;
CREATE DATABASE etools;
GRANT ALL PRIVILEGES ON DATABASE etools TO etoolusr;
EOSQL

echo "*** UPDATING DATABASE ***"
export DB_DUMP_LOCATION=/tmp/psql_data/db1.bz2
bzcat $DB_DUMP_LOCATION | nice pg_restore --verbose  -U etoolusr -F t -d etools
# bzcat $DB_DUMP_LOCATION | nice pg_restore --verbose  -U etoolusr -F c -d etools

echo "*** DATABASE CREATED ***"
