FROM ghcr.io/arquitecturas-concurrentes/iasc-rvm-debian-slim:main

# preinstall some ruby versions
ENV REQUIRED_RUBIES "2.7.2 jruby-9.2.20.0"
RUN /bin/bash -l -c 'for version in $REQUIRED_RUBIES; do echo "Now installing Ruby $version"; rvm install $version; rvm cleanup all; done'

RUN /bin/bash -l -c 'rvm alias create mri ruby-2.7.2 && \
  rvm alias create jruby jruby-9.2.20.0'

# /app will have the puma practice
RUN mkdir /app
WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .

# install the deps for each used ruby
RUN /bin/bash -l -c 'rvm use mri && bundle install && \
  rvm use jruby && bundle install'
COPY . .

# Try to slim a bit the image
RUN apt-get remove -yq g++ gcc 

RUN ./generate_file.bash

# expose the port
EXPOSE 9292

# login shell by default so rvm is sourced automatically and 'rvm use' can be used
CMD /bin/bash -c htop
