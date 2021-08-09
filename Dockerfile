ARG VARIANT="2019-latest"
FROM mcr.microsoft.com/mssql/server:"${VARIANT}" as build

# Sets the database connection variables.
ENV DB_MSSQL_USER=sa
ENV DB_MSSQL_PASSWORD=Test123!!
ENV DB_MSSQL_DATABASE=master

# Sets default environment variables of the mssql image.
ENV MSSQL_PID=Developer
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=$DB_MSSQL_PASSWORD

USER root

ENV MSSQL_BACKUP_DIR="/var/opt/sqlserver"
ENV MSSQL_DATA_DIR="/var/opt/sqlserver"
ENV MSSQL_LOG_DIR="/var/opt/sqlserver"

COPY create-dir-stuct.sh /tmp/create-dir-struct;
RUN /bin/bash /tmp/create-dir-struct && \
    rm /tmp/create-dir-struct

# Sets the variable to inform Docker that the container
# listens on the specified network port.
EXPOSE 1433/tcp

# Expose port for SQL Server Agent
EXPOSE 1434/udp
VOLUME [ "/var/opt/mssql/data" ]

USER mssql
CMD [ "/opt/mssql/bin/sqlservr" ]
