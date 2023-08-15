FROM ruby:3.2.2-alpine3.18 AS build

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh build-base gcc wget git

COPY Gemfile Gemfile.lock .

RUN gem install bundler:2.4.18 && \
    bundle config set without 'development test' && \
    bundle install

RUN bundle install

FROM ruby:3.2.2-alpine3.18 AS runtime

RUN apk add --no-cache bash

WORKDIR /opt/representer

COPY --from=build /usr/local/bundle /usr/local/bundle

COPY . .

ENTRYPOINT ["sh", "/opt/representer/bin/run.sh"]
