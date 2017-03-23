import platform

from fabric.api import local, env, settings
from fabric.context_managers import shell_env

def ssh(service):
    local('docker exec -it etoolsinfra_%s_1 /bin/sh' % service)

def devup(quick=False):
    local('docker-compose -f docker-compose.dev.yml up --force-recreate %s' % ('--build' if not quick else ''))

def devup_debug(quick=False, ip='192.168.240.248', p='51312'):
    '''
        make sure the debugger is running
        run ipconfig getifaddr en0 to get your IP address
        fab devup_debug:True,ip=192.168.240.248,p=51312
    '''
    with shell_env(BACKEND_DEBUG="_debug", DEBUG_IP=ip, DEBUG_PORT=p):
        local('docker-compose -f docker-compose.dev.yml up --force-recreate %s' % ('--build' if not quick else ''))

def backend_migrations():
    local('docker exec etoolsinfra_backend_1 python /code/EquiTrack/manage.py migrate_schemas --noinput')

def up(quick=False):
    local('docker-compose -f docker-compose.yml up --force-recreate')

def _frontend_deps_init():
    # TODO retry after timeouts
    local('git submodule foreach npm install')
    local('git submodule foreach bower install')

def _frontend_deps_update():
    # TODO retry after timeouts
    local('git submodule foreach npm update')
    local('git submodule foreach bower update')

def _update_submodules(branch='develop'):
    # TODO retry after timeouts
    local('git submodule sync')
    local('git submodule update --init --recursive')
    # proxy has no develop branch, so skip it
    local('git submodule foreach \'[ "$path" == "proxy" ] || git checkout --force %s\'' % branch)
    # TODO add something to pull master for proxy... or change to use develop
    local('git submodule foreach \'[ "$path" == "proxy" ] || git pull origin %s\'' % branch)

def update(branch='develop'):
    local('git fetch --all')
    # TODO should we use `develop` on unicef/etools-infra rather than `master`?
    # local('git checkout --force %s' % branch)
    _update_submodules(branch)
    _frontend_deps_update()


def init(branch='develop'):
    local('git fetch --all')

    _update_submodules(branch)
    _frontend_deps_init()

    if platform.system() == 'Darwin':
        # TODO complain if postgres and/or GDAL are not installed
        pass
    if platform.system() == 'Linux':
        # TODO complain if postgres and/or GDAL are not installed
        pass
    if platform.system() == 'Windows':
        # TODO complain if postgres and/or GDAL are not installed
        pass
