#!/usr/bin/env bash

create=true;
mksudo=true;
user= ;
shell=/bin/bash;
home_dir= ;

run() {
    home_dir="${home_dir:-/home/$user}";

    if [ ! -d "/home/${user}" ]; then
        mkdir -p "/home/${user}";
    fi

    exists="$(grep 'mssql:' < /etc/passwd | awk -F':' '{ print $1 }')"
    if [ "${create}" ] && [ -z "${exists}" ]; then
        useradd -s "${shell}" -d "/home/${user}";
        echo "${user}:${user}" | chpasswd
    fi

    if [ "${mksudo}" ]; then
        if [ ! -d /etc/sudoers.d ]; then
            mkdir -p /etc/sudoers.d;
        fi

        adduser "${user}" sudo
    fi

    if [ -n "${shell}" ]; then
        chsh -s "${shell}" "${user}"
    fi

    # Attempted fix at "./.sysem could not be created error"
    if [ "$user" = "root" ]; then
        useradd -M -s /bin/bash -u 10001 -g 0 mssql && \
        chgrp -R 0 /var/opt/mssql
    fi
}

main() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -u | --user)
                user="$2";
                echo "$2";
                shift 2;;

            -s | --shell)
                shell="$2";
                shift 2;;

            -h | --home)
                home_dir="$2";
                shift 2;;

            -nc | --no-create-user)
                create=false;
                shift;;

            -ns | --no-sudo)
                mksudo=false;
                shift;;
        esac
    done
}

main "$@";

if [ -z "${user}" ]; then
    echo "'--user' is a required parameter" 1>&2;
    exit 1;
fi

run;
