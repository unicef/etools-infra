#!/bin/bash
export PGUSER="postgres"

echo "*** RESORING DATABASE ***"
bzcat /db/db_file.bz2 | nice pg_restore -U etoolusr -F t -d etools
