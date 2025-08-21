FROM ghcr.io/arquitecturas-concurrentes/iasc-rvm-debian-slim:main

# preinstall some ruby versions
ENV REQUIRED_RUBIES="3.4.0 jruby-10.0.2.0"
RUN /bin/bash -l -c 'for version in $REQUIRED_RUBIES; do echo "Now installing Ruby $version"; rvm install $version; rvm cleanup all; done'

RUN /bin/bash -l -c 'rvm alias create mri ruby-3.4.0'
RUN /bin/bash -l -c 'rvm alias create jruby jruby-10.0.2.0'

# /app will have the puma practice
RUN mkdir /app
WORKDIR /app

COPY Gemfile .
COPY clean_n_build.bash .

# install the deps for each used ruby
RUN /bin/bash -l -c 'rvm use mri'
RUN /bin/bash -l -c 'bundle install'
RUN /bin/bash -l -c 'rvm use jruby'
RUN /bin/bash -l -c 'bundle install'
COPY . .

# Try to slim a bit the image
RUN apt-get remove -yq g++ gcc

RUN ./generate_file.bash

# expose the port
EXPOSE 9292

# start with the ruby mri version
RUN /bin/bash -l -c 'rvm use mri'
RUN /bin/bash -l -c 'rvm rvmrc warning ignore /app/.rvmrc'

# login shell by default so rvm is sourced automatically and 'rvm use' can be used
ENTRYPOINT ["/bin/bash"]
