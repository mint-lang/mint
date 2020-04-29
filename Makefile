.PHONY: build
build:
	shards build --error-on-warnings --error-trace

.PHONY: spec
spec:
	crystal spec --error-on-warnings --error-trace

.PHONY: formatter
formatter:
	crystal tool format --check

.PHONY: ameba
ameba:
	bin/ameba

.PHONY: test
test: spec formatter ameba

.PHONY: test-core
test-core: build
	cd core/tests && ../../bin/mint test

.PHONY: development
development: build
	cp bin/mint ~/.bin/mint-dev

.PHONY: documentation
documentation:
	rm -rf docs && crystal docs
