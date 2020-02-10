DB_PORT="51322"
CMD=docker-compose -f docker-compose.dev.yml

help:
	@echo ''
	@echo 'Usage:'
	@echo '   make ssh SERVICE=<service>     ssh into container'
	@echo '   make reallyclean               remove docker containers'
	@echo '   make devup_build               re/build containers and start'
	@echo '   make devup                     start containers'
	@echo '   make devup_windows		 start containers on windows'
	@echo '   make devup_windows_build	 re/build and start on windows'
	@echo '   make backend_migrations	 run backend migrations'
	@echo '   make stop			 stop containers'
	@echo '   make remove			 remove containers'
	@echo '   make start			 start containers'
	@echo '   make test			 run backend tests'
	@echo '   make test APP=<app>		 run backend tests for app'
	@echo ''


ssh:
	docker exec -it etoolsinfra_${SERVICE} /bin/sh


reallyclean:
	${CMD} down --rmi all --volumes
	docker volume rm $$(docker volume ls -qf dangling=true)


devup:
	DB_PORT=${DB_PORT} ${CMD} up --force-recreate


devup_build:
	DB_PORT=${DB_PORT} ${CMD} up --force-recreate --build


devup_windows:
	${CMD} -f docker-compose.dev-built-win.yml up --force-recreate


devup_windows_build:
	${CMD} -f docker-compose.dev-built-win.yml up --force-recreate --build


backend_migrations:
	${CMD} exec backend python /code/manage.py migrate_schemas --noinput


stop:
	${CMD} stop


remove:
	${CMD} stop
	${CMD} rm


start:
	${MAKE} devup


test:
	${CMD} exec backend python /code/core/manage.py test --keepdb


test_app:
	${MAKE} test ${APP}.tests
