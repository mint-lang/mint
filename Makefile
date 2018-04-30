build:
	crystal build src/mint.cr -o mint -p && mv mint ~/.bin/mint && mint

test:
	crystal spec -p
