FROM ruby:3.0.2
WORKDIR /app
COPY . /app
RUN gem install httparty activesupport paint
CMD ["/bin/sh", "echo hello"]
