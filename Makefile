.PHONY: build
build:
	shards build --error-on-warnings --error-trace --progress

.PHONY: spec
spec:
	crystal spec --error-on-warnings --error-trace --progress

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
	cd core/tests && ../../bin/mint test -b firefox

.PHONY: development
development: build
	mv bin/mint ~/.bin/mint-dev

.PHONY: local
local: build
	mv bin/mint ~/.bin/mint

.PHONY: documentation
documentation:
	rm -rf docs && crystal docs
