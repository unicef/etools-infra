DB_PORT="51322"
CMD=docker-compose -f docker-compose.dev.yml

help:
	@echo ''
	@echo 'Usage:'
	@echo '   make update			 update images/repos'
	@echo '   make docker-compose		 build docker-compose file'
	@echo '   make reallyclean		 remove docker containers'
	@echo '   make devup_build		 re/build containers and start'
	@echo '   make devup			 start containers'
	@echo '   make devup_windows		 start containers on windows'
	@echo '   make devup_windows_build	 re/build and start on windows'
	@echo '   make backend_migrations	 run backend migrations'
	@echo '   make stop			 stop containers'
	@echo '   make remove			 remove containers'
	@echo '   make run			 start containers'
	@echo '   make build_run		 re/build and start containers'
	@echo '   make ssh SERVICE=<service>	 ssh into container'
	@echo '   make restart SERVICE=<service> restart container'
	@echo '   make rm SERVICE=<service> 	 rm container'
	@echo '   make test			 run backend tests'
	@echo '   make test APP=<app>		 run backend tests for app'
	@echo '   make restore FILE=<file>       restore DB with provided file'
	@echo ''


ssh:
	docker exec -it etools_${SERVICE} /bin/sh


restart:
	${CMD} restart ${SERVICE}


rm:
	${CMD} rm ${SERVICE}


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
	${CMD} run backend python manage.py migrate_schemas --noinput


stop:
	${CMD} stop


remove:
	${CMD} stop
	${CMD} rm


run:
	${MAKE} devup


build_run:
	${MAKE} devup_build


test:
	${CMD} run backend python manage.py test --keepdb


test_app:
	${MAKE} test ${APP}.tests


update:
	./scripts/update.sh
	${MAKE} docker-compose


docker-compose:
	./scripts/template.sh


restore:
	./scripts/restore_db.sh
