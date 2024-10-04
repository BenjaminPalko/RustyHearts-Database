FROM mcr.microsoft.com/mssql-tools:latest

ARG SERVER_PUBLIC_IP
ARG SQL_HOST
ARG SQL_PASSWORD

ENV MSSQL_HOST=${SQL_HOST}
ENV MSSQL_SA_PASSWORD=${SQL_PASSWORD}

WORKDIR /usr/src/app

COPY ./db ./db
RUN sed -i "s/<SERVER_PUBLIC_IP>/${SERVER_PUBLIC_IP}/g" ./db/setup_auth.sql
COPY ./entrypoint.sh .
RUN ["chmod", "+x", "/usr/src/app/entrypoint.sh"]

ENTRYPOINT ./entrypoint.sh
