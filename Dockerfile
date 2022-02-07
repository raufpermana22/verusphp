FROM ruby:latest
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn 
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
# This installs bundler 2x. Change if you need any of the older versions
RUN gem install bundler:2.1.2
ADD Gemfile* $APP_HOME/
# This is a bundler 2 format. For bundler 1, you can add --without development test to the bundle install line
RUN bundle config set without 'development test'
RUN bundle install
ADD . $APP_HOME
# if you're not using webpack, you can comment out the following line
RUN yarn install --check-files
RUN SECRET_KEY_BASE=$SECRET_KEY_BASE RAILS_ENV=production bundle exec rake assets:precompile
