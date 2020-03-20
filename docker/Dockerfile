FROM ruby:2.7.0-alpine

RUN apk update && apk add build-base postgresql-dev && apk add --update tzdata

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3030

CMD ["bundle", "exec", "rails", "server", "-P", "3030"]
