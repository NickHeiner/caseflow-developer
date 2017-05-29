FROM ruby

RUN gem install foreman
RUN apt-get update -yqq \
    && apt-get install -yqq build-essential \
    postgresql-client \
    nodejs \
    npm \
    qt5-default \
    libqt5webkit5-dev
RUN npm install -g yarn
RUN npm install -g n
RUN n v6.10.3

WORKDIR /usr/src/app
COPY Gemfile* ./

RUN bundle install
run ln -s /usr/bin/nodejs /usr/bin/node
COPY . .
EXPOSE 5000
