FROM ruby:3.4.3-slim

WORKDIR /football_now

# Copy only the Gemfile and Gemfile.lock first
COPY Gemfile Gemfile.lock ./

# Install bundler and dependencies in a single layer to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && gem install bundler --no-document \
    && bundle config set --local without 'development test' \
    && bundle install --jobs 20 --retry 5 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove build-essential

# Create regular user with explicit UID/GID
RUN groupadd --gid 1000 football && \
    useradd --uid 1000 --gid 1000 --shell /bin/bash --create-home football

# Copy the rest of the application code with correct ownership
COPY --chown=football:football . /football_now/

# Switch to the regular user
USER football

CMD ["bundle", "exec", "rake", "start:football_now"]
