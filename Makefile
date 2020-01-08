crystal_build = crystal build src/mint.cr --progress --error-trace

development:
	$(crystal_build) -o mint-dev && \
	mv mint-dev ~/.bin/mint-dev && mint-dev

build:
	$(crystal_build) -o mint && \
	mv mint ~/.bin/mint && mint

test:
	crystal spec -p --error-trace && bin/ameba

test-core:
	$(crystal_build) -o mint && \
	cd core/tests && ../../mint test && cd ../../ && rm mint

documentation:
	rm -rf docs && crystal docs
