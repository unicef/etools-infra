## eTools backend infrastructure configuration

This repository is meant to help get an etools development environment up and running.
It is *not* used for any production setup.

The repo is basically a collection of submodules, each of which represents a different docker service
that is part of etools.

### Notes:

To start using this please get familiar with git submodules if you haven't used them before:

    - https://git-scm.com/book/en/v2/Git-Tools-Submodules
    - https://github.com/blog/2104-working-with-submodules

Some knowledge of Docker is also extremely helpful. There's a cheatsheet
in this repo at docs/docker-cheatsheet.md.

### Dependencies

- [Python 3.9](https://www.python.org/downloads/)
- [Virtualenv](https://virtualenv.pypa.io/en/stable/)
- [Virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/)
- [Docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/install/) (version 1.14 or higher)

### Dev Setup

 - Make sure you have dependencies installed

 - Clone the repo: `git clone git@github.com:unicef/etools-infra.git`

 - Setup a virtualenv: `mkvirtualenv -p $(type -p python3.9) --no-site-packages etools`

 - Install fabric: `pip install fabric3`

 - Change to the etools-infra directory: `cd etools-infra`

 - Initialize submodules and build front-end javascript: `fab init`.
   Apparently it's normal to see lots of warnings from npm and bower,
   just ignore them.

 - Contact the Dev Lead to get your db dump, name it `db1.bz2` and add it to: `./db/`.
   You can copy or hardlink it, just don't use a symbolic link as that doesn't
   seem to work.

 - Run: `fab devup` in the parent folder and wait for it. This should restore the database to the db container.

   - ***Note: you will likely see some error messages from the DB saying
     "ERROR: could not open extension control file" or similar.
     This is okay. When you see "etoolsinfra_backend exited with code 124" and it
     seems to be hung, let it keep running. Eventually you'll start seeing more output
     from the db_1 container.
     Then when you see "etoolsinfra_db exited with code 1", CTRL-C, wait for all the
     containers to stop, and run `fab devup` again.***

   - When `fab devup` is successful, the last thing you'll see is a `runserver` startup. Then it'll
     sit and show the docker logs until you kill it. It will not exit on its own.
     You should leave it running, and continue in another
     window.  (see the doc for `docker-compose up`, that's what devup does.)

 - At this point you could bring migrations up to speed by running `fab backend_migrations`,
   but if you restored from a production backup, that could take a very long time due to
   all the schemas and data. In that case just keep following these instructions.
   After the first time, `fab backend_migrations` can be used more quickly.

 - Subsequent starts can be run with `fab devup:quick`

 - ***Localhost server should be running on 8082*** - i.e. you can visit the
   web site at http://localhost:8082.

 - To SSH into a web container `fab ssh:backend` (to run `manage.py createsuperuser` or other commands)

 - The database container should be accesible on the host machine on port 51322. The port can be changed by passing it as a parameter to the `fab devup` commands.

 ```bash
	fab ssh:backend
	# create super user (choose public schema when asked)
	python manage.py createsuperuser

	# run schema migrations
	python manage.py migrate_schemas --noinput --schema=public

	# open python shell and reduce the number of countries. (This gets rid of all but a few countries.)
	python manage.py shell
	from EquiTrack.util_scripts import *
	local_country_keep()
	quit()

	# run migrations scripts
	python manage.py migrate_schemas --noinput

	# import currencies data
	python manage.py import_exchange_rates

	exit
 ```

Finally, login to localhost:8082/admin/login to finalize setting up your user:

- In the `auth.User` model make sure to set available countries

- In the `users.UserProfile` model, make sure to select a country and/or a country override

You should now be able to access frontend apps.

- When you're done working, CTRL-C the `fab devup` to shutdown the containers.

### Clean up/start over

If you want to stop and remove all the containers, images, and volumes that
this tool has created, run:

```bash
    fab reallyclean
```

That *will* delete all data from the docker environments along with everything
else, so backup the database first if you need it.

### Getting latest changes

Getting the latest changes should be a two-step process:

```bash
   fab update
   fab devup:quick
```

`fab update` will pull in the latest submodule changes and update all front-end dependencies, which can be slow
and is not always necessary.
You can also run `fab update:quick` which will only pull code changes and not update the front-end dependencies.

### Dev Setup on Windows 10 requirements

 - Enable Hyper-V (PowerShell opened with Administrator rights: `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`)
 - Install Docker for Windows, stable channel: https://docs.docker.com/docker-for-windows/install/#download-docker-for-windows
 - Open Docker Settings and add your shared partitions (the one that contains the folder you are gonna install etools)
 - Install [Python 3.7](https://www.python.org/downloads/) and [update your system environment `Path` variable](https://docs.python.org/3/using/windows.html#finding-the-python-executable)
 - Open GitBash/CMD/PowerShell and run `pip install fabric3`
 - Do `Dev Setup` steps to install the project

### Docker help

See [Docker Cheatsheet](./docs/docker-cheatsheet.md) for some quick tips for working with docker.

### Running the Backend Locally

See [Local Backend Setup](./docs/running-local-backend-tests.md) for instructions on running the backend
not in a docker container, which can be faster/easier to manage.

### Prod-like environ setup

Coming soon...
