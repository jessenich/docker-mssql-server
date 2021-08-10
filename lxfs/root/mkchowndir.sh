#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "A user is required" 1>&2;
    exit 1;
elif [ -z "$2" ]; then
    echo "A directory path is required" 1>&2;
    exit 2;
fi

unset -v __user;
unset -v __dir;
__user="$1";
__dir="$2";

mkdir -p "${__dir}";
chown "${__user}" "${__dir}";

exit 0;
