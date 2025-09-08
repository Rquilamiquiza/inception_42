FILE = -f srcs/compose.yml
COMPOSE = docker compose
CERTS_DIR = ./secrets/certs
CERT_KEY = $(CERTS_DIR)/server.key
CERT_CRT = $(CERTS_DIR)/server.crt

certs: $(CERT_KEY) $(CERT_CRT)

$(CERT_KEY) $(CERT_CRT):
	mkdir -p $(CERTS_DIR)
	openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048\
    -keyout $(CERT_KEY)\
    -out $(CERT_CRT)\
    -subj "/CN=localhost"

build:
	$(COMPOSE) $(FILE) build

up: certs build
	$(COMPOSE) $(FILE) up -d --build

down:
	$(COMPOSE) $(FILE) down

restart: down up

clean:
	$(COMPOSE) $(FILE) down -v --remove-orphans

