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

def debug(quick=False, DEBUG_PORT='51312'):
    try:
        import netifaces as ni
    except ImportError:
        print "You must have the 'netifaces' package installed"
    ni.ifaddresses('en0')
    ip = ni.ifaddresses('en0')[2][0]['addr']
    with shell_env(BACKEND_DEBUG="_debug", DEBUG_IP=ip, DEBUG_PORT=DEBUG_PORT):
        local('docker-compose -f docker-compose.dev.yml up --force-recreate %s' % ('--build' if not quick else ''))

def remove_docker_containers():
    local('docker stop $(docker ps -q)')
    local('docker rm $(docker ps -q)')


def up(quick=False):
    local('docker-compose -f docker-compose.yml up --force-recreate')
