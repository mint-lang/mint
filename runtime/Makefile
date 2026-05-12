.PHONY: index
index:
	bunx esbuild index.js \
		--outfile=../src/assets/runtime.js \
		--log-override:equals-nan=silent \
		--format=esm \
		--minify \
		--bundle

.PHONY: index_testing
index_testing:
	bunx esbuild index_testing.js \
		--outfile=../src/assets/runtime_test.js \
		--log-override:equals-nan=silent \
		--format=esm \
		--minify \
		--bundle

.PHONY: format
format:
	bunx prettier --write *.js **/*.js

.PHONY: test
test:
	bunx vitest --coverage
