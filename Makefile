build:
	shards build --error-on-warnings --error-trace

test-core: build
	cd core/tests && ../../bin/mint test

documentation:
	rm -rf docs && crystal docs
