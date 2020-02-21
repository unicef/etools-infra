#!/bin/bash
CONFIG=config.cfg
CONFIG_DEFAULT=config.cfg.defaults

config_read_file() {
    FILE="$(cd "$(dirname "${1}")"; pwd -P)/$(basename "${1}")"
    (grep -E "^${2}=" -m 1 "${FILE}" 2>/dev/null || echo "VAR=__UNDEFINED__") | head -n 1 | cut -d '=' -f 2-;
}

# check if user has overwritten default
# if config has 'repo` value, then using repos
# otherwise use value as image
# if not overwritten in config then use default image
APP_LIST="$(config_read_file config.cfg.defaults "APPS")"
for i in ${APP_LIST[*]}
do
    printf "\n:: updating ${i} ::\n\n"

    IMAGE="$(config_read_file config.cfg "${i}")";
    # use repos
    if [ "${IMAGE}" == "repo" ]; then
        printf "Using repo\n"
        if [ -d "${i}" ]; then
            # if directory exists pull
            cd "${i}"; git pull origin; cd ../
        else
            # otherwise clone
            REPO="$(config_read_file config.cfg.defaults "${i}_repo")";
            if [ "${REPO}" != "__UNDEFINED__" ]; then
                git clone "${REPO}" "${i}"
            else
                printf "${i}_repo not defined in defaults\n"
            fi
        fi
    # user user defined image
    elif [ "${IMAGE}" != "__UNDEFINED__" ]; then
        printf "${i} image overwritten to ${IMAGE}\n"
        docker pull "${IMAGE}"
    # use default image
    else
        IMAGE="$(config_read_file config.cfg.defaults "${i}_image")";
        if [ "${IMAGE}" != "__UNDEFINED__" ]; then
            printf "Using default image ${IMAGE}\n"
            docker pull "${IMAGE}"
        else
            printf "${i}_image not defined in defaults\n"
        fi
    fi
done
