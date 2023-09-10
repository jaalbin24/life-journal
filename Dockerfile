# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copy the Gemfile and Gemfile.lock into the image and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the rest of your Rails application code into the image
COPY . .

# Set environment variables for production
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

# Precompile assets
RUN bundle exec rails assets:precompile

# Start the Rails application server
CMD ["bundle", "exec", "rails", "server", "-e", "production"]
