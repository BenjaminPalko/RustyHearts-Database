FROM mcr.microsoft.com/mssql-tools:latest

WORKDIR /usr/src/app

COPY ./db ./db
COPY ./entrypoint.sh .
RUN ["chmod", "+x", "/usr/src/app/entrypoint.sh"]

ENTRYPOINT ./entrypoint.sh
