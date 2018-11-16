FROM ruby:2.5

RUN apt-get update && apt-get install -y build-essential nodejs mysql-client

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

ARG BUNDLE_ARGS

# --deployment --without development test
RUN bundle check || bundle install --jobs $(nproc) --retry 5 --binstubs $BUNDLE_ARGS

COPY . .

# EXPOSE 3000

CMD ["puma"]
