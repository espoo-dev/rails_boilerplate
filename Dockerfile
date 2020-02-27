FROM ruby:2.7

# update apt cache and install dependencies
RUN apt-get update && apt-get install git curl build-essential libssl-dev libreadline-dev zlib1g-dev sqlite3 libsqlite3-dev -y

# utils
RUN apt-get install nano -y

# install recent node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install nodejs -y

# install recent yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y

# install bundler
RUN gem install bundler
# install rails
RUN gem install rails -v 6.0.0
RUN apt-get update 
# solve rails problem with timezone
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

# add edimossilva user
RUN apt-get install sudo -y
RUN adduser --gecos '' --disabled-password edimossilva
RUN adduser edimossilva sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER edimossilva

# config home environment
WORKDIR /home/edimossilva/development/volume
ENV HOME /home/edimossilva

RUN sudo chown edimossilva:edimossilva /home/edimossilva/*
