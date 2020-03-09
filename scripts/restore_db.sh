#!/bin/bash
CMD="docker-compose -f docker-compose.dev.yml"

if [ -z ${FILE} ]; then
    printf "FILE is required\n"
    exit 0;
fi
cp "${FILE}" ./db/db_file.bz2
printf "${CMD} run db /db/restore.sh\n"

${CMD} run db -w /db bash restore.sh
