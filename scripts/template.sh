#!/bin/bash
CONFIG=config.cfg
CONFIG_DEFAULT=config.cfg.defaults
PYTHON_LIB_DIR=build/libs/
LIB_DIR="backend/${PYTHON_LIB_DIR}"
DOCKER_COMPOSE=docker-compose.dev.yml
PYTHON_PATH="PYTHONPATH: \${PYTHONPATH}"

config_read_file() {
    FILE="$(cd "$(dirname "${1}")"; pwd -P)/$(basename "${1}")"
    (grep -E "^${2}=" -m 1 "${FILE}" 2>/dev/null || echo "VAR=__UNDEFINED__") | head -n 1 | cut -d '=' -f 2-;
}

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN"
esac

if [ "${MACHINE}" == "UNKNOWN" ]; then
    printf "Unknown system: ${unameOut}\n"
    exit 0;
fi

replace_text() {
    if [ "${MACHINE}" == "Linux" ]; then
        sed -i 's+'"${1}"'+'"${2}"'+' "${DOCKER_COMPOSE}"
    elif [ "${MACHINE}" == "Mac" ]; then
        sed -i '' 's+'"${1}"'+'"${2}"'+' "${DOCKER_COMPOSE}"
    else
        get-content "${DOCKER_COMPOSE}" | %{$_ -replace "$1","$2"}
    fi
}

# backup current docker-compose.dev.yml file
cp "./${DOCKER_COMPOSE}" "./${DOCKER_COMPOSE}.bak"
# copy template to docker-compose.dev.yml
cp ./templates/docker-compose.dev.tpl.yml "./${DOCKER_COMPOSE}"

# APPS
# if config has 'repo` value, then need to build
# otherwise use image
APP_LIST="$(config_read_file config.cfg.defaults "APPS")"
for i in ${APP_LIST[*]}
do
    printf "\n:: processing ${i} ::\n\n"

    IMAGE="$(config_read_file config.cfg "${i}")";
    # use repos
    if [ "${IMAGE}" == "repo" ]; then
        # get repo value from configs
        REPO="$(config_read_file config.cfg.defaults "${i}_repo")";
        if [ "${REPO}" == "__UNDEFINED__" ]; then
            printf "${i}_repo is undefined. Check config files\n"
        else
            printf "${i} is using the repo\n"
            if [ "${i}" == "backend" ]; then
                replace_text "<backend-image>" "build:\n\
      context: ${i}\n\
      dockerfile: ./Dockerfile-dev\n\
      args:\n\
        REQUIREMENTS_FILE: test.txt\n\
    image: etoolsdev/etools-backend:dev\
"
            else
                replace_text "<${i}-image>" "build:\n\
      context: ./${i}\n\
      dockerfile: ./Dockerfile-dev\n\
    image: etoolsdev/etools-${i}:dev\
"
            fi
        fi
    else
        # if image not overwritten use default image
        if [ "${IMAGE}" == "__UNDEFINED__" ]; then
            IMAGE="$(config_read_file config.cfg.defaults "${i}_image")";
        fi
        if [ "${IMAGE}" == "__UNDEFINED__" ]; then
            printf "${i}_image is undefined. Check config files\n"
        else
            printf "${i} is using image ${IMAGE}\n"
            replace_text "<${i}-image>" "image: ${IMAGE}"
        fi
    fi
done


# LIBS
# can only set libs pythonpath
# if any dirs in libs dir
printf "\n:: checking libraries ::\n\n"
LIB_LIST="$(config_read_file config.cfg.defaults "LIBS")"
EXISTS=false
for i in ${LIB_LIST[*]}
do
    LIB_PATH="$(config_read_file config.cfg.defaults "lib_${i}_path")";
    if [ "${LIB_PATH}" != "__UNDEFINED__" ]; then
        if [ -d "${LIB_DIR}/${LIB_PATH}" ]; then
            # library in use, want to set pythonpath
            EXISTS=true
            printf "using library locally: ${LIB_PATH}\n"
            PYTHON_PATH="${PYTHON_PATH}:/code/${PYTHON_LIB_DIR}${LIB_PATH}/src"
        fi
    fi
done

printf "\n"

# attempt to clear pythonlib entry
# if already set then nothing will happen
# otherwise cleared
if [ "${EXISTS}" = true ]; then
    replace_text "<pythonpath>" "${PYTHON_PATH}"
else
    replace_text "<pythonpath>" ""
fi
