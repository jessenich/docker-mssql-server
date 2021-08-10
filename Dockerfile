ARG VARIANT="2019-latest"
FROM mcr.microsoft.com/mssql/server:"${VARIANT}" as build

LABEL maintainer="Jesse N. <jesse@keplerdev.com>"
LABEL org.opencontainers.image.source="https://github.com/jessenich/docker-mssql-server"

# Sets the database connection variables.
ENV DB_MSSQL_USER=sa \
    DB_MSSQL_PASSWORD=Test123!! \
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

ENV MSSQL_SYSTEM_DIR="/var/opt/mssql" \
    MSSQL_BACKUP_DIR="/var/opt/mssql/backup/" \
    MSSQL_DATA_DIR="/var/opt/mssql/data/" \
    MSSQL_LOG_DIR="/var/opt/mssql/log/"

ADD https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb packages-microsoft-prod.deb
COPY ./lxfs /
RUN export DEBIAN_NONINTERACTIVE=true && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        wget \
        apt-transport-https \
        software-properties-common && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    add-apt-repository universe && \
    apt-get install -y \
        powershell && \
    rm -f packages-microsoft-prod.deb 2>/dev/null && \
    /bin/bash /root/mkchowndir.sh mssql "${MSSQL_BACKUP_DIR}" && \
    /bin/bash /root/mkchowndir.sh mssql "${MSSQL_DATA_DIR}" && \
    /bin/bash /root/mkchowndir.sh mssql "${MSSQL_LOG_DIR}" && \
    rm -rf /tmp/buildx;

VOLUME "${MSSQL_SYSTEM_DIR}" \
       "${MSSQL_BACKUP_DIR}" \
       "${MSSQL_DATA_DIR}" \
       "${MSSQL_LOG_DIR}"

# Sets the variable to inform Docker that the container
# listens on the specified network port.
EXPOSE 1433/tcp \
       1434/udp

USER mssql
WORKDIR /home/mssql
CMD [ "/opt/mssql/bin/sqlservr" ]
