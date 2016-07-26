 FROM ruby:2.3
 RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
 RUN mkdir /shelter
 WORKDIR /shelter
 ADD Gemfile /shelter/Gemfile
 ADD Gemfile.lock /shelter/Gemfile.lock
 RUN bundle install
 ADD . /shelter