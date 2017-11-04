<h1 align="center">
  LFGamer
</h1>

<p align="center">
[![Codeship Status for Greg-Rose/LFGamer](https://app.codeship.com/projects/7818bf70-3f49-0135-80bf-5264315189ea/status?branch=master)](https://app.codeship.com/projects/229751)
![Code Climate](https://codeclimate.com/github/Greg-Rose/LFGamer.png)
[![Coverage Status](https://coveralls.io/repos/github/Greg-Rose/LFGamer/badge.svg?branch=master)](https://coveralls.io/github/Greg-Rose/LFGamer?branch=master)
</p>

<p align="center">
  A social networking site for gamers to find and connect with other people to play with.
</p>

![alt text](/demo-screenshot.png "Demo Screenshot")

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

You will need Ruby installed on your computer. Ruby version 2.4.1 was used during development.

You will also need PostgreSQL installed - http://postgresapp.com (Mac).

### Installing

```bash
# Clone source
$ git clone https://github.com/Greg-Rose/LFGamer.git LFGamer
$ cd LFGamer

# Install bundler
$ gem install bundler

# Bundle install dependencies
$ bundle install

# Create and migrate database
$ rake db:create
$ rake db:migrate

# Run application, by default starts at localhost:3000
$ rails s

```

Visit the site in your browser at localhost:3000.

To give a user admin status and/or try out admin functionality:

```bash
# Run rails consoles
$ rails c

# Get the user you want to give admin status, for example:
$ new_admin = User.last

# Set admin status
$ new_admin.update_attributes(admin: true)
```

## Running the tests

Tests include both JavaScript and non-JavaScript enabled tests.

```bash
# To run non-JavaScript tests:
$ rspec . -t ~js:true
```

To run the JavaScript enabled tests you will need to install PhantomJS

```bash
# Install node and npm
$ brew install node

# Install PhantomJS
$ npm install phantomjs-prebuilt

# Run JS tests
$ rspec . -t js:true

# Run all tests
$ rspec
```
