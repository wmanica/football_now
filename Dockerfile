FROM ruby:3.2.2
WORKDIR /football_now
COPY Gemfile Gemfile.lock ./
RUN gem install bundler \
    && bundle install --jobs 20 --retry 5
COPY . /football_now
CMD ["bundle", "exec", "rake", "start:football_now"]
