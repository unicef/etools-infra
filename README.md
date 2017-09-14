## eTools backend infrastructure configuration

This repository is meant to help get an etools development environment up and running.
It is *not* used for any production setup.

The repo is basically a collection of submodules, each of which represents a different docker service
that is part of etools.

### Notes:

To start using this please get familiar with git submodules if you haven't used them before:
    - https://git-scm.com/book/en/v2/Git-Tools-Submodules
    - https://github.com/blog/2104-working-with-submodules

### Dependencies

- [Python 2.7](https://www.python.org/downloads/)
- [Virtualenv](https://virtualenv.pypa.io/en/stable/)
- [Virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/)
- [Docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/install/) (version 1.14 or higher)

### Dev Setup

 - Make sure you have dependencies installed
 - Clone the repo: `git clone https://github.com/unicef/etools-infra.git`
 - Setup a virtualenv: `mkvirtualenv --no-site-packages etools`
 - Install fabric: `pip install fabric`
 - Initialize submodules and build front-end javascript: `fab init`
 - Contact the Dev Lead to get your db dump, name it `db1.bz2` and add it to: `./db/`
 - Run: `fab devup` in the parent folder and wait for it. This should restore the database to the db container.
   - ***Note: you will likely see some error messages from the DB saying "ERROR: could not open extension control file" or similar.
   This is okay. Just wait for the process to finish and exit, then `CTRL-C` and run `fab devup` again.***
 - To bring migrations up to speed `fab backend_migrations`
 - Subsequent starts can be run with `fab devup:quick`
 - ***Localhost server should be running on 8082***
 - To SSH into a web container `fab ssh:backend` (to run `manage.py createsuperuser` or other commands)
 

 ```bash
	fab ssh:backend
	cd EquiTrack
	# create super user
	python manage.py createsuperuser

	# run schema migrations
	python manage.py migrate_schemas --noinput --schema=public

	# open python shell and reduce the number of countries
	python manage.py shell
	from EquiTrack.util_scripts import *
	local_country_keep()
	quit()

	# run migrations scripts
	python manage.py migrate_schemas --noinput

	# import currencies data 
	python manage.py import_exchange_rates
	
 ```

Finally, login to localhost:8082/admin/login to finalize setting up your user:

- In the `auth.User` model make sure to set available countries
- In the `users.UserProfile` model, make sure to select a country and/or a country override

You should now be able to access frontend apps.
 
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
 - Install Python 2.7.13 and update your system environment `Path` variable by adding `C:\Python27` and `C:\Python27\Scripts`
 - Open GitBash/CMD/PowerShell and run `pip install fabric`
 - Do `Dev Setup` steps to install the project 

### Docker help

See [Docker Cheatsheet](./docs/docker-cheatsheet.md) for some quick tips for working with docker.

### Running the Backend Locally

See [Local Backend Setup](./docs/running-local-backend-tests.md) for instructions on running the backend
not in a docker container, which can be faster/easier to manage.

### Prod-like environ setup

Coming soon...
