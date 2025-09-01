FROM debian:bookworm

RUN  apt-get update && apt-get install -y \
     mariadb-server \
     mariadb-client \
     && rm -rf /var/lib/apt/lists/*

#cria o diretorio para os scripts de inicializacao
RUN mkdir -p /docker-entrypoint-initdb.d/

COPY init_db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init_db.sh

RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf


EXPOSE 3306

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]