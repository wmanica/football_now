FROM ruby:3.0.2
WORKDIR /football_now
COPY . /football_now/
RUN gem install bundler \
    && bundler update
CMD ["/bin/sh","-c","ruby app/football_now.rb"]
