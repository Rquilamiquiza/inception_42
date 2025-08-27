FROM debian:bullseye

RUN  apt-get update && apt-get install -y \
     mariadb-server \
     mariadb-client \
     && rm -rf /var/lib/apt/lists/*

#cria o diretorio para os scripts de inicializacao
RUN mkdir -p /docker-entrypoint-initdb.d/

COPY 


