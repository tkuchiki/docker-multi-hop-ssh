.PHONY:	build up ssh

build:
	mkdir -p ssh
ifeq (,$(wildcard ssh/id_rsa))
	ssh-keygen -f ./ssh/id_rsa -N '' -t rsa
endif
	docker-compose build

up:
	docker-compose up -d

ssh:
	ssh -F ssh_config ssh_container
