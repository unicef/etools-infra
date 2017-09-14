# Running the Backend / Backend Tests Locally

If you want to run the backend and/or tests locally (not in a docker container) you can follow these steps.

## First create a local virtualenv and install all requirements

(in the env)

```
$ pip install -r backend/Equitrack/requirements/local.txt
```

*If you have issues with `GDAL` you may be able to get away with just commenting it out of the requirements file.*

## Setup your environment variables

Setup the environment variables appropriately in your local environment.

See [this post](https://stackoverflow.com/a/11134336/8207) for instructions/theory, or just edit the following two files as follows:

In `$VIRTUAL_ENV/bin/postactivate` add the following:

```
export VISION_URL=https://devapis.unicef.org/BIService/BIWebService.svc
export SECRET_KEY=
export DJANGO_DEBUG=true
export VISION_PASSWORD=
export DJANGO_SETTINGS_MODULE=EquiTrack.settings.local
export VISION_USER=
export PYTHONUNBUFFERED=1
export DATABASE_URL=postgis://etoolusr:@localhost:5432/etools
export REDIS_URL=redis://localhost:6379/0
```

And `$VIRTUAL_ENV/bin/predeactivate` add the following:

```
unset VISION_URL
unset SECRET_KEY
unset DJANGO_DEBUG
unset VISION_PASSWORD
unset DJANGO_SETTINGS_MODULE
unset VISION_USER
unset PYTHONUNBUFFERED
unset DATABASE_URL
unset REDIS_URL
```

You may need to adjust some of these variables as needed to match your local environment.

## Run the DB container alone

`$ docker-compose -f docker-compose.dev.yml up -d db`

## Run backend

(In the virtual environment)

Replace the test with whatever you want to run.

```
$ cd backend/EquiTrack
$ ./manage.py runserver
```

Your server should hopefully be running at http://localhost:8000.
You can login at http://localhost:8000/admin/login.

## Run tests

(Again, in the virtual environment)

Replace the test with whatever you want to run.

```
$ cd backend/EquiTrack
$ ./manage.py test partners.tests.test_api_interventions --keepdb
```

The `--keepdb` argument is optional but highly recommended.
It will reuse the db after each test, and is much faster if rebuilding the database isn't necessary.
