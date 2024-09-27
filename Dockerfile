
FROM mcr.microsoft.com/mssql/server:2022-latest

ARG SERVER_PUBLIC_IP
ARG SQL_PASSWORD

ENV ACCEPT_EULA="Y"
ENV MSSQL_SA_PASSWORD=${SQL_PASSWORD}

USER root

# RUN apt-get update -y && apt-get install mssql-tools -y

WORKDIR /usr/src/app

COPY ./databases.sql ./setup_auth.sql ./entrypoint.sh ./
RUN sed -i "s/<SERVER_PUBLIC_IP>/${SERVER_PUBLIC_IP}/g" setup_auth.sql

USER mssql
ENTRYPOINT ./entrypoint.sh
