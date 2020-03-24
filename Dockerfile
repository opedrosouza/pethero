FROM ruby:2.6

LABEL maintainer="pedrossouza.com.br"

RUN apt-get update -qq && apt-get install -y\
  build-essential\
  nodejs

RUN mkdir /api
WORKDIR /api

COPY api/Gemfile /api/Gemfile
COPY api/Gemfile.lock /api/Gemfile.lock
RUN gem install bundler && bundle install
COPY ./api /api
RUN rm -f /api/tmp/pids/server.pid

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]