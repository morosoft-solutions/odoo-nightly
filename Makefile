THIS_FILE := $(lastword $(MAKEFILE_LIST))
ifneq (,$(wildcard ./.env))
    include .env
    export
endif
.PHONY: help nightly fetch process clean flush
help:
	make -pRrq  -f $(THIS_FILE) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

nightly: clean fetch process flush
	

fetch:
	wget https://nightly.odoo.com/${ODOO_VERSION}/nightly/src/odoo_${ODOO_VERSION}.latest.tar.gz

process:
	tar -xvzf odoo_${ODOO_VERSION}.latest.tar.gz
	mv odoo-13.0.*/odoo/* .
	mv odoo-13.0.*/README.md .
	mv odoo-13.0.*/requirements.txt .

flush:
	rm -f odoo_${ODOO_VERSION}.latest.tar.gz
	rm -Rf odoo-13.0.*

clean:
	find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec rm -Rf {} +
	find . -mindepth 1 -maxdepth 1 -type f ! -name '.*' ! -name 'Makefile' ! -name 'README.md' ! -name 'requirements.txt' -exec rm -f {} +
