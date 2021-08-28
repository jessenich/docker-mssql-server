user= ;
shell=/bin/zsh;
run() {
    if [ ! -d "/home/'${user}" ]; then
        mkdir -p "/home/${user}";
    fi

    exists="$(grep 'mssql:' < /etc/passwd | awk -F':' '{ print $1 }')"

    if [ -z "${exists}" ]; then
        useradd -s "${shell}" -d "/home/${user}";
        echo "${user}:${user}" | chpasswd
    fi

    if [ ! -d /etc/sudoers.d ]; then
        mkdir -p /etc/sudoers.d;
        adduser "${user}" sudo
    fi

    cp /etc/zsh/zshrc_template "/home/${user}/.zshrc";
}

main() {
    while "$#" -gt 0; do
        case "$1" in
            -u | --user)
                user="$2";
                shift;;

            --use-ash-shell)
                zsh=/bin/ash;
                shift;;
        esac
    done
}
