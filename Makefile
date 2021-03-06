BUILDDIR=build
PATTERN=etools

DOCKER_CONTAINERS=$(shell docker ps -a -f "name=${PATTERN}")
DOCKER_IMAGES=$(shell docker images|grep '${PATTERN}')
DOCKER = docker


help:
	@echo '                                                                               '
	@echo 'Usage:                                                                         '
	@echo '   make info                 gives information regarding images and containers '
	@echo '   make ssh                  ssh into backend container                        '
	@echo '   make migrations           run backend migrations                            '
	@echo '   make init                 initialize the environment                        '
	@echo '   make devup                run the environment                               '
	@echo '   make clean                get rid of images and containers                  '
	@echo '                                                                               '


info:
	@echo 'DOCKER CONTAINERS'
	@docker ps -a -f name=${PATTERN}infra
	@echo '                                                                               '
	@echo '-------------------------------------------------------------------------------'
	@echo '                                                                               '
	@echo 'DOCKER IMAGES'
	@docker images "etoolsdev/${PATTERN}*"


ssh:
	@docker exec -it etoolsinfra_backend /bin/bash


migrations:
	@docker exec -it etoolsinfra_backend python /code/manage.py migrate --noinput


init:
	@docker-compose -f docker-compose.dev.yml up --force-recreate --build


build:
	@docker-compose -f docker-compose.dev.yml up --force-recreate


devup:
	@docker-compose -f docker-compose.dev.yml up


clean:
	docker rm $$(docker ps -a -f name=${PATTERN}infra -q)
	docker rmi $$(docker images "etoolsdev/${PATTERN}*" -q)
