# Ensure that this Ruby version matches the version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.3
FROM ruby:$RUBY_VERSION

# Install dependencies for Active Storage preview, PostgreSQL, Node.js, and Yarn
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libvips \
    bash \
    bash-completion \
    libffi-dev \
    tzdata \
    postgresql-client \
    nodejs \
    npm \
    yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Set Rails app directory
WORKDIR /app

# Set environment variables for Rails
ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="development" \
    BUNDLE_WITHOUT=""

# Copy the entire application code into the container
COPY . .

# Install gems based on the Gemfile
RUN bundle install

# Precompile bootsnap code for faster startup times
RUN bundle exec bootsnap precompile --gemfile ./Gemfile ./app ./lib

# Precompile assets for production, without requiring the secret key
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Specify the entrypoint script (database setup, etc.)
ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Expose port 3000 for Rails server
EXPOSE 3000

# Default command to run the Rails server
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
