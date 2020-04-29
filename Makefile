.PHONY: build
build:
	shards build --error-on-warnings --error-trace

.PHONY: test-core
test-core: build
	cd core/tests && ../../bin/mint test

.PHONY: development
development: build
	cp bin/mint ~/.bin/mint-dev

.PHONY: documentation
documentation:
	rm -rf docs && crystal docs
