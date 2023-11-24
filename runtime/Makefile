build:
	yarn esbuild index.js \
		--log-override:equals-nan=silent \
		--outfile=../src/assets/runtime.js \
		--format=esm \
		--minify \
		--bundle

format:
	yarn prettier --write src/**
