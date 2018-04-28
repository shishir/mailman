
FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /mailman
WORKDIR /mailman
COPY Gemfile /mailman/Gemfile
COPY Gemfile.lock /mailman/Gemfile.lock
RUN bundle install
COPY . /mailman
