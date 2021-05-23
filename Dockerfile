# We are using crystal as image we are building the binary on
FROM crystallang/crystal:latest-alpine AS build

# Create a build directory and set it as default
RUN mkdir -p /opt/mint
WORKDIR /opt/mint

# Copy source
COPY . .

# Install dependencies (shards)
RUN shards install

# Build binary
RUN shards build --static --no-debug --release

# This will be the actual base image
FROM alpine

# Install imagemagick (to generate favicons) and git (to install dependencies)
RUN apk add --update --no-cache imagemagick bash pngcrush optipng git less openssh

# Copy the binary
COPY --from=build /opt/mint/bin/mint /bin/mint

# Set the binary as entrypoint
ENTRYPOINT [ "/bin/mint" ]

# Set the default command as the server
CMD [ "start" ]
