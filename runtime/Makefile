.PHONY: index
index:
	yarn esbuild index.js \
		--log-override:equals-nan=silent \
		--outfile=../src/assets/runtime.js \
		--format=esm \
		--minify \
		--bundle

.PHONY: test
test:
	yarn esbuild index_testing.js \
		--log-override:equals-nan=silent \
		--outfile=../src/assets/runtime_test.js \
		--format=esm \
		--minify \
		--bundle

format:
	yarn prettier --write *.js **/*.js
