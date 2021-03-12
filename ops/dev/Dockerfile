FROM registry-bosa-docker.bosa.belighted.com/bosa-city-base:latest

# Configure locale, bundler, define app dir
ENV BUNDLE_WITHOUT=production:test
ENV BUNDLE_WITH=development
ENV RAILS_ENV=development
ENV NODE_ENV=development

COPY Gemfile* /app/

# Upgrade RubyGems, add github to known_hosts, add .gitconfig, install required Bundler version
RUN bundle check || bundle install
