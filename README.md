## eTools backend infrastructure configuration

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
 - Clone the repo: `git clone --recursive https://github.com/unicef/etools-infra.git`
 - Setup a virtualenv: `mkvirtualenv --no-site-packages etools`
 - Set the correct branches you want to work from for each submodule (eg: develop in PMP, staging in backend, etc)
 - Install fabric: `pip install fabric`
 - Contact the Dev Lead to get your db dump, name it `db1.bz2` and add it to: `./db/`
 - For frontend apps `npm install` and `bower install` first in the local directories:
   - `git submodule foreach npm install`
   - run `bower install` in the subdirectories: `dashboard`, `pmp`, and `travel`
 - Run: `fab devup` in the parent folder and wait for it. (this should update your db) ***sometimes db doesn't start first try, `CTRL-C` and run the command again.***
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
	from util_scripts import *
	local_country_keep()
	quit()

	# run migrations scripts
	python manage.py migrate_schemas --noinput

	# import currencies data 
	python manage.py import_exchange_rates
	
 ```

 - login to localhost:8082/admin/login edit your user, set country and other stuff, then access frontend apps
 
 
### Dev Setup on Windows 10 requirements

 - Enable Hyper-V (PowerShell opened with Administrator rights: `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`)
 - Install Docker for Windows, stable channel: https://docs.docker.com/docker-for-windows/install/#download-docker-for-windows
 - Open Docker Settings and add your shared partitions (the one that contains the folder you are gonna install etools)
 - Install Python 2.7.13 and update your system environment `Path` variable by adding `C:\Python27` and `C:\Python27\Scripts`
 - Open GitBash/CMD/PowerShell and run `pip install fabric`
 - Do `Dev Setup` steps to install the project 

### Prod-like environ setup

Coming soon...
