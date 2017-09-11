# Docker Cheatsheet

## Overview

This project makes heavy use of docker both in development and in production.
This document contains snippets that are useful for accomplishing various tasks with docker.

## Local commands

Normally you'll use `fab devup` and `fab devup:quick` to start/stop your local docker containers,
but sometimes you need more fine grained control.

### Deleting a container

To fully delete an image you can run

`docker rm [container id or name]`

For example, `docker rm etoolsinfra_db_1` should remove the db container.
After you do this you will need to rebuild it (typically with `fab devup`).

### Running a single container (in the backround)

To run just a single container, use the following:

`docker-compose -f docker-compose.dev.yml up db`

If you want to run it in the background, just add `-d`

`docker-compose -f docker-compose.dev.yml up -d db`

You can stop it with `docker stop`. E.g.

`docker stop etoolsinfra_db_1`

### Stop all running containers

Useful in case you've started a bunch of stuff in the background.

`docker stop $(docker ps -a -q)`

### Rebuilding a single container in place

Sometimes you just want to rebuild an image in place - e.g. if you make changes to the proxy config file.
You can do this with:

`docker-compose -f docker-compose.dev.yml build [container name]`

E.g.

`docker-compose -f docker-compose.dev.yml build [container name]`

### Cleaning up

See [this gist](https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430) for some useful cleanup commands.
In particular, when frequently rebuilding the DB container, the following can be very useful for reclaiming disk space:

`docker volume ls -qf dangling=true | xargs -r docker volume rm`

## Docker Cloud

UNICEF's dev/demo/staging infrastructure runs on docker cloud.
While most things can be managed in the cloud UI, it's nice to be able to troubleshoot environments on the command line.

To do that you first have to setup [docker-cloud CLI](https://docs.docker.com/docker-cloud/installing-cli/#getting-started).

Don't forget to add these two lines to your `.bashrc` to avoid having to enter them every time:

```
export DOCKER_ID_USER=[your username]
export DOCKERCLOUD_NAMESPACE=unicef
```

From there you can use the standard CLI options. Some useful commands:

### Login

`docker login`

### List all containers

`docker-cloud container ps`

### Get a shell on a container

`docker-cloud exec [container id]`

or if `bash` is installed

`docker-cloud exec [container id] bash`

*Note that you must use container ids (e.g. "6b9e2155") and not names ("haproxy-dev-1").*
You can get the ids from `docker-cloud container ps`.
