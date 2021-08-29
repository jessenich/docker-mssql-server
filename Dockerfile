ARG VARIANT="2019-latest"
FROM mcr.microsoft.com/mssql/server:"${VARIANT}" as build

LABEL maintainer="Jesse N. <jesse@keplerdev.com>"
LABEL org.opencontainers.image.source="https://github.com/jessenich/docker-mssql-server"

# Sets the database connection variables.
ENV DB_MSSQL_USER=sa \
    DB_MSSQL_PASSWORD= \
    DB_MSSQL_DATABASE=master \
    TZ="${TZ:-America/NewYork}" \
    TERM="xterm-256color" \
    RUNNING_IN_DOCKER=true \
    HOME="${HOME:-/home/mssql}"

# Sets default environment variables of the mssql image.
ENV MSSQL_PID=Developer \
    ACCEPT_EULA=Y \
    SA_PASSWORD=$DB_MSSQL_PASSWORD

USER root

ENV MSSQL_SYSTEM_DIR="/var/opt/mssql/system" \
    MSSQL_BACKUP_DIR="/var/opt/mssql/backup" \
    MSSQL_DATA_DIR="/var/opt/mssql/data" \
    MSSQL_LOG_DIR="/var/opt/mssql/log"


COPY ./lxfs /
RUN export DEBIAN_NONINTERACTIVE=1 && \
    chown mssql /usr/local/sbin/add-sudo-user.sh && \
    chown mssql /usr/local/sbin/mkdir-chown.sh && \
    chown mssql /usr/local/sbin/install-oh-my.sh;

RUN apt-get update 2>/dev/null && \
    apt-get install -y \
        agent-transfer \
        apt-transport-https \
        ca-certificates \
        curl \
        git \
        gnupg \
        gnupg-agent \
        gnupg-utils \
        libcppdb-dev \
        libcppdb0 \
        libcppdb-odbc0 \
        libcppdb-sqlite3-0 \
        libcppdb-mysql0 \
        libcppdb-postgresql0 \
        man-db \
        openssh-client \
        openssh-known-hosts \
        openssh-server \
        openssh-sftp-server \
        software-properties-common \
        sqlite3 \
        sqlite3-doc \
        sqlite3-pcre \
        sudo \
        wget \
        zsh \
        zsh-doc;

# Install oh-my-bash and oh-my-zsh
RUN /bin/bash /usr/local/sbin/install-oh-my.sh;

RUN chsh -s /bin/zsh root && \
    chsh -s /bin/zsh mssql;

# Install PowerShell 7
ADD https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    add-apt-repository universe && \
    apt-get install -y \
        powershell && \
    rm -f packages-microsoft-prod.deb 2>/dev/null;

# Install oh-my-posh
RUN pwsh -NoProfile -NonInteractive -NoLogo -File /usr/local/sbin/install-oh-my-posh.ps1

# Create volume directories
RUN export DEBIAN_NONINTERACTIVE=1 && \
    /bin/bash /usr/local/sbin/mkdir-chown.sh mssql "${MSSQL_SYSTEM_DIR}" && \
    /bin/bash /usr/local/sbin/mkdir-chown.sh mssql "${MSSQL_BACKUP_DIR}" && \
    /bin/bash /usr/local/sbin/mkdir-chown.sh mssql "${MSSQL_DATA_DIR}" && \
    /bin/bash /usr/local/sbin/mkdir-chown.sh mssql "${MSSQL_LOG_DIR}";

VOLUME "${MSSQL_SYSTEM_DIR}" \
       "${MSSQL_BACKUP_DIR}" \
       "${MSSQL_DATA_DIR}" \
       "${MSSQL_LOG_DIR}"

EXPOSE 1433
EXPOSE 1434

USER mssql
WORKDIR /home/mssql
CMD [ "/opt/mssql/bin/sqlservr" ]
