FROM postgis/postgis:12-3.1

RUN apt-get update && apt-get install -y --no-install-recommends bzip2 postgresql-12-pgpool2

RUN mkdir -p /tmp/psql_data/
COPY ./db1.bz2 /tmp/psql_data/
COPY load_db_data.sh /docker-entrypoint-initdb.d/20_load_db_data.sh
