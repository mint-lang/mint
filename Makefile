.PHONY: build
build: bin/mint

.PHONY: spec
spec:
	crystal spec --error-on-warnings --error-trace --progress

.PHONY: format
format:
	crystal tool format

.PHONY: format-core
format-core: build
	cd core && ../bin/mint format
	cd core/tests && ../../bin/mint format

.PHONY: ameba
ameba:
	bin/ameba

.PHONY: test
test: spec ameba

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

src/assets/runtime.js: $(shell find runtime/src -type f)
	cd runtime && make

# This builds the binary and depends on files in some directories.
bin/mint: $(shell find src -type f) $(shell find core/source -type f) $(shell find runtime/src -type f)
	shards build --error-on-warnings --error-trace --progress
