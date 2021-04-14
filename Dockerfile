# We are using crystal as image we are building the binary on
FROM crystallang/crystal:latest-alpine AS build

# Create a build directory and set it as default
RUN mkdir -p /opt/build
WORKDIR /opt/build

# Copy source
COPY . .

# Install dependencies (shards)
RUN shards install --ignore-crystal-version

# Build binary
RUN crystal build src/mint.cr -o mint --static --no-debug

# This will be the actual base image
FROM alpine

# Install imagemagic (to generate favicons) and git (to install dependencies)
RUN apk add --update --no-cache imagemagick bash pngcrush optipng git less openssh

# Copy the binary
COPY --from=build /opt/build/mint /bin/mint

# Set the binary as entrypoint
ENTRYPOINT [ "/bin/mint" ]

# Set the default command as the server
CMD [ "start" ]
