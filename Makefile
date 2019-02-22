development:
	crystal build src/mint.cr -o mint-dev -p && \
	mv mint-dev ~/.bin/mint-dev && mint-dev

build:
	crystal build src/mint.cr -o mint -p && mv mint ~/.bin/mint && mint

test:
	crystal spec -p && bin/ameba

test-core:
	crystal build src/mint.cr -o mint -p && cd core && ../mint test && cd .. && rm mint

documentation:
	rm -rf docs && crystal docs
