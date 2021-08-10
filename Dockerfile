ARG VARIANT="2019-latest"
FROM mcr.microsoft.com/mssql/server:"${VARIANT}" as build

LABEL maintainer="Jesse N. <jesse@keplerdev.com>"
LABEL org.opencontainers.image.source="https://github.com/jessenich/docker-mssql-server"

# Sets the database connection variables.
ENV DB_MSSQL_USER=sa
ENV DB_MSSQL_PASSWORD=Test123!!
ENV DB_MSSQL_DATABASE=master

# Sets default environment variables of the mssql image.
ENV MSSQL_PID=Developer
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=$DB_MSSQL_PASSWORD

USER root

ENV MSSQL_SYSTEM_DIR="/var/opt/mssql"
ENV MSSQL_BACKUP_DIR="/var/opt/mssql/backup"
ENV MSSQL_DATA_DIR="/var/opt/mssql/data"
ENV MSSQL_LOG_DIR="/var/opt/mssql/log"

WORKDIR /tmp
COPY lxfs/create-dir-struct.sh ./create-dir-struct.sh
RUN chmod +x ./create-dir-struct.sh && \
    /bin/bash create-dir-struct.sh && \
    rm ./create-dir-struct.sh

# Sets the variable to inform Docker that the container
# listens on the specified network port.
EXPOSE 1433/tcp

# Expose port for SQL Server Agent
EXPOSE 1434/udp

USER mssql
WORKDIR /home/mssql
CMD [ "/opt/mssql/bin/sqlservr" ]
