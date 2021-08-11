user= ;
shell=/bin/zsh;
run() {
    if [ ! -d "/home/'${user}" ]; then
        mkdir -p "/home/${user}";
    fi

    adduser -D "${user}" -h "/home/${user}" -s "${shell}";

    if [ ! -d /etc/sudoers.d ]; then
        mkdir -p /etc/sudoers.d;
    fi

    echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}";
    chmod 0440 "/etc/sudoers.d/${user}";
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
