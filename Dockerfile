FROM ruby:2.6.6-alpine3.13

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN gem install bundler -v 2.3.6

WORKDIR /opt/representer

COPY Gemfile Gemfile.lock .

RUN bundle install

COPY . .

ENTRYPOINT ["sh", "/opt/representer/bin/run.sh"]
