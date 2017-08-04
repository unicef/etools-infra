import platform

from fabric.api import local, env, settings
from fabric.context_managers import shell_env, lcd


APP_SUBMODULE_DIRECTORIES = (
    'dashboard',
    'pmp',
    'travel',
)


def ssh(service):
    local('docker exec -it etoolsinfra_%s_1 /bin/sh' % service)

def devup(quick=False):
    local('docker-compose -f docker-compose.dev.yml up --force-recreate %s' % ('--build' if not quick else ''))

def devup_built(quick=False):
    nginx_config = " -c '/nginx-built.conf'"
    front_end_command = "node express.js"
    with shell_env(NX_CONFIG=nginx_config, FE_COMMAND=front_end_command):
        local('docker-compose -f docker-compose.dev.yml up --force-recreate %s' % ('--build' if not quick else ''))

def backend_migrations():
    local('docker exec etoolsinfra_backend_1 python /code/EquiTrack/manage.py migrate_schemas --noinput')

def debug(quick=False, DEBUG_PORT='51312'):
    try:
        import netifaces as ni
    except ImportError:
        print "You must have the 'netifaces' package installed"
        return
    ni.ifaddresses('en0')
    ip = ni.ifaddresses('en0')[2][0]['addr']
    with shell_env(BACKEND_DEBUG="_debug", DEBUG_IP=ip, DEBUG_PORT=DEBUG_PORT):
        local('docker-compose -f docker-compose.dev.yml up --force-recreate %s' % ('--build' if not quick else ''))

def remove_docker_containers():
    local('docker stop $(docker ps -q)')
    local('docker rm $(docker ps -q)')

def stop_docker_containers():
    local('docker stop $(docker ps -q)')


def up(quick=False):
    local('docker-compose -f docker-compose.yml up --force-recreate')


def _frontend_deps_init():
    # TODO retry after timeouts
    for frontend_app_dir in APP_SUBMODULE_DIRECTORIES:
        with lcd(frontend_app_dir):
            local('npm install')
            local('bower install')


def _frontend_deps_update():
    # TODO retry after timeouts
    for frontend_app_dir in APP_SUBMODULE_DIRECTORIES:
        with lcd(frontend_app_dir):
            local('npm update')
            local('bower update')


def _update_submodules(branch='develop'):
    # TODO retry after timeouts
    # see https://stackoverflow.com/a/18799234/8207 for more information about submodule branch tracking
    local('git submodule sync')
    local('git submodule update --init --recursive --remote')
    local('git submodule foreach -q --recursive \'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch\'')


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

def test(app=None):
    # TODO figure out a better way to do this...
    local('docker exec -it etoolsinfra_db_1 /usr/bin/psql -d template1 -c '
          '\'create extension if not exists hstore;\' -U etoolusr')
    # TODO add flag so caller can indicate --keepdb vs --noinput
    if app is not None:
        local('docker exec etoolsinfra_backend_1 python'
              '  /code/EquiTrack/manage.py test %s.tests --keepdb' % app)
    else:
        local('docker exec etoolsinfra_backend_1 python'
              ' /code/EquiTrack/manage.py test --keepdb')
