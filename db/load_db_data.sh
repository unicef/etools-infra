#!/bin/bash

set -e

export DB_DUMP_LOCATION=/tmp/psql_data/db1.bz2

echo "*** CREATING DATABASE ***"

# create default database

psql -c "CREATE ROLE etoolusr WITH superuser login;"
psql -c "CREATE DATABASE etools;"
psql -c "GRANT ALL PRIVILEGES ON DATABASE etools TO etoolusr;"


echo "*** UPDATING DATABASE ***"
#bzcat $DB_DUMP_LOCATION | nice pg_restore --verbose  -U etoolusr -F t -d etools
bzcat $DB_DUMP_LOCATION | nice pg_restore -U etoolusr -F c -d etools

echo "*** DATABASE CREATED ***"
