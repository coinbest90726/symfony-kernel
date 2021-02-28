#!make
# include .env
# export $(shell sed 's/=.*//' .env)

# Setup ————————————————————————————————————————————————————————————————————————
DOCKER_COMPOSE                = docker-compose
PROJECT_DIR                   = /var/www/symfony5_microkernel
DOCKER_BASH                   = docker exec -ti symfony5_microkernel bash
DOCKER_EXEC                   = ${DOCKER_BASH} -c
PROJECT_DIR                   = $(shell pwd)


## —— 📦  Drinks & Co test Makefile 📦 ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— 🐋  Docker 🐋 ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
build: upgrade composer ## First run / installation will call this target

up: ## Start the docker environment
	$(DOCKER_COMPOSE) up -d --remove-orphans

upgrade: ## Pull new docker images
	$(DOCKER_COMPOSE) pull
	$(DOCKER_COMPOSE) up -d --remove-orphans

destroy: ## Destroy docker environment but without removing persistent data
	$(DOCKER_COMPOSE) down --remove-orphans

recreate: ## Recreates entire docker environment or 'SERVICE' provided | usage: (make recreate) (make recreate SERVICE=php)
	$(DOCKER_COMPOSE) up -d --force-recreate $(SERVICE)

restart: ## Restart the docker environment
	$(DOCKER_COMPOSE) restart

status: ## Restart the docker environment
	$(DOCKER_COMPOSE) ps

info: ## List Docker containers for the project
	$(DOCKER_COMPOSE) images

## —— 🐘  PHP container 🐘 ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
ssh-php: ## ssh to the php container on symfony 5 microkernel working dir
	$(DOCKER_BASH)

test:
	$(DOCKER_EXEC) 'php bin/phpunit'

composer: ## Install vendors according to the current composer.lock file on sf5 microkernel
	$(DOCKER_EXEC) 'php -d memory_limit=-1 composer.phar install --no-interaction --optimize-autoloader'

composer-update: ## Update vendors on sf5 microkernel or single provided 'PACKAGE' | usage: (make composer-update) (make composer-update PACKAGE={package})
	$(DOCKER_EXEC) 'php -d memory_limit=-1 composer.phar update --no-interaction $(PACKAGE)'

composer-require: ## Install new composer package on sf5 microkernel | usage: (make composer-require PACKAGE={package})
	$(DOCKER_EXEC) 'php -d memory_limit=-1 composer.phar require $(PACKAGE) --no-interaction'

