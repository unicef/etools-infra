from fabric.api import local, env, settings


def ssh(service):
    local('docker exec -it etoolsinfra_%s_1 /bin/sh' % service)

def devup(quick=False):
    local('docker-compose -f docker-compose.dev.yml up --force-recreate %s' % ('--build' if not quick else ''))

def up(quick=False):
    local('docker-compose -f docker-compose.yml up --force-recreate')
