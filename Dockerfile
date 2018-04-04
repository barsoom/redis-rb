# This is a quick way to run the tests on any computer with docker installed.

# Run this:
# docker build . -t redis-rb-dev && docker run -t redis-rb-dev

FROM ruby:2.5-alpine
RUN apk add --no-cache git build-base linux-headers

WORKDIR /redis-rb

# Only bundle gems if changed
COPY Gemfile redis.gemspec ./
COPY lib/redis/version.rb ./lib/redis/version.rb
RUN bundle

# Add redis server used to run tests
COPY makefile .
COPY test/test.conf.erb ./test/test.conf.erb
RUN make tmp/redis-unstable/src/redis-server

COPY . .

CMD make test
