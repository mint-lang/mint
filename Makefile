development:
	crystal build src/mint.cr -o mint-dev -p --error-trace && \
	mv mint-dev ~/.bin/mint-dev

build:
	crystal build src/mint.cr -o mint -p --error-trace --release && mv mint ~/.bin/mint && mint

test:
	crystal spec -p --error-trace && bin/ameba

test-core:
	crystal build src/mint.cr -o mint -p --error-trace && cd core/tests && ../../mint test && cd ../../ && rm mint

documentation:
	rm -rf docs && crystal docs
