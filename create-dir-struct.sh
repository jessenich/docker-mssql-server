#!/user/bin/env bash

if [ -n "${MSSQL_BACKUP_DIR}" ]; then
    if [ ! -d "${MSSQL_BACKUP_DIR}" ]; then
        mkdir -p "${MSSQL_BACKUP_DIR}";
        chown mssql "${MSSQL_BACKUP_DIR}"
    fi
fi

if [ -n "${MSSQL_DATA_DIR}" ]; then
    if [ ! -d "${MSSQL_DATA_DIR}" ]; then
        mkdir -p "${MSSQL_DATA_DIR}";
        chown mssql "${MSSQL_DATA_DIR}"
    fi
fi

if [ -n "${MSSQL_LOG_DIR}" ]; then
    if [ ! -d "${MSSQL_LOG_DIR}" ]; then
        mkdir -p "${MSSQL_LOG_DIR}";
        chown mssql "${MSSQL_LOG_DIR}"
    fi
fi
