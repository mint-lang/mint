.PHONY: index
index:
	yarn esbuild index.js \
		--outfile=../src/assets/runtime.js \
		--log-override:equals-nan=silent \
		--format=esm \
		--minify \
		--bundle

.PHONY: index_testing
index_testing:
	yarn esbuild index_testing.js \
		--outfile=../src/assets/runtime_test.js \
		--log-override:equals-nan=silent \
		--format=esm \
		--minify \
		--bundle

.PHONY: format
format:
	yarn prettier --write *.js **/*.js

.PHONY: test
test:
	yarn vitest --coverage
