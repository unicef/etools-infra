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
This should include anything you need to override, for example, the `DATABASE_URL` if you're using the docker database (as described below).

See [this post](https://stackoverflow.com/a/11134336/8207) for instructions/theory, or just edit the following two files as follows:

In `$VIRTUAL_ENV/bin/postactivate` add the following:

```
export DATABASE_URL=postgis://etoolusr:@localhost:5432/etools
```

And `$VIRTUAL_ENV/bin/predeactivate` add the following:

```
unset DATABASE_URL
```

You can add/adjust these variables as needed to match your local environment.

## Run the DB container alone

`$ docker-compose -f docker-compose.dev.yml up -d db`

## Run backend

(In the virtual environment)

```
$ cd backend/EquiTrack
$ ./manage.py runserver
```

Your server should hopefully be running at http://localhost:8000.
You can login at http://localhost:8000/admin/login.

## Run tests

(Again, in the virtual environment)

You can run all tests as follows:

```
$ cd backend/EquiTrack
$ ./runtests.sh
```

The `runtests.sh` script, in addition to running tests, will also check coverage, run flake8 and has other nice features/default settings.

You can also run the tests through the normal django runner (which is helpful for just running individual tests).
Just replace the test with whatever you want to run.

```
$ cd backend/EquiTrack
$ ./manage.py test partners.tests.test_api_interventions --keepdb
```

The `--keepdb` argument is optional but highly recommended.
It will reuse the db after each test, and is much faster if rebuilding the database isn't necessary.
