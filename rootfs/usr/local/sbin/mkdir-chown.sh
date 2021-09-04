#!/usr/bin/env bash


__user= ;
__dir= ;

run() {
    if [ ! -d "${__dir}" ]; then
        mkdir -p "${__dir}";
    fi

    chown "${__user}" "${__dir}";
    chown 10001:0 "${__dir}"
    exit 0;
}


main() {

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -u | --user)
                __user="$2";
                shift 2;;

            -d | --dir)
                __dir="$2";
                shift 2;;

            *)
                shift;;
        esac
    done

}

main "$@";
run;
