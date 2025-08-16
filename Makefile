FILE = -f srcs/compose.yml
COMPOSE = docker compose


up:
	$(COMPOSE) $(FILE) up -d

build:
	$(COMPOSE) $(FILE) build

down:
	$(COMPOSE) $(FILE) down

restart: down up

clean:
	$(COMPOSE) $(FILE) down -v --remove-orphans

