build:
	crystal build src/mint.cr -o mint -p && mv mint ~/.bin/mint && mint

test:
	crystal spec -p && bin/ameba

documentation:
	rm -rf docs && crystal docs
