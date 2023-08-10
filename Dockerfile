FROM ruby:2.6.6-alpine3.13 AS build

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh build-base gcc wget git

RUN gem install bundler -v 2.3.6

COPY Gemfile Gemfile.lock .

RUN bundle install

FROM ruby:2.6.6-alpine3.13 AS runtime

RUN apk add --no-cache bash

WORKDIR /opt/representer

COPY --from=build /usr/local/bundle /usr/local/bundle

COPY . .

ENTRYPOINT ["sh", "/opt/representer/bin/run.sh"]
