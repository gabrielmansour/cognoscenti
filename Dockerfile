# this is a sub-image used only to install/compile the ruby gems for alpine
FROM ruby:2.5.7-alpine as bundler

WORKDIR /app/

COPY Gemfile* /app/

RUN apk add --no-cache build-base linux-headers git libffi-dev \
                       postgresql-dev tzdata bind-tools

RUN gem install bundler -v 2.1.4

RUN bundle install --jobs 5

# ------------------------------------------------------------------------------
FROM ruby:2.5.7-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache build-base linux-headers git libffi-dev \
                       postgresql-dev tzdata bind-tools

RUN gem install bundler -v 2.1.4

# copy all the gems from the 'bundler' sub-image to this image
COPY --from=bundler $BUNDLE_PATH $BUNDLE_PATH

COPY . /usr/src/app

RUN chmod +x /usr/src/app/entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
