# Use an official Ruby runtime as a parent image
FROM registry.home:5000/ruby:3.2.2

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Copy the Gemfile and Gemfile.lock into the image and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the rest of your Rails application code into the image
COPY . .

# Copy the CA certificate into the container
COPY ./root_cert.crt /usr/local/share/ca-certificates/root_cert.crt

# Update CA certificates in the container
RUN update-ca-certificates

# Precompile assets
RUN bundle exec rails assets:precompile

# Set environment variables for production
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

# We'll need port 3000 to access the app
EXPOSE 3000

# Start the Rails application server
CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-e", "production"]