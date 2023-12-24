FROM ruby:3.2-bookworm AS build
RUN apt-get update \
  && apt-get install libffi-dev nodejs -y \
  && apt-get clean
RUN gem install bundler \
  && mkdir -p /usr/src/app/source
WORKDIR /usr/src/app/
COPY Gemfile /usr/src/app
RUN bundle install
COPY config.rb /usr/src/app
COPY source /usr/src/app/source
RUN middleman build --verbose

FROM httpd:2.4
COPY --from=build /usr/src/app/build /usr/local/apache2/htdocs/
