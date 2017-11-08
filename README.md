# LFGamer

[![Codeship Status for Greg-Rose/LFGamer](https://app.codeship.com/projects/7818bf70-3f49-0135-80bf-5264315189ea/status?branch=master)](https://app.codeship.com/projects/229751)
![Code Climate](https://codeclimate.com/github/Greg-Rose/LFGamer.png)
[![Coverage Status](https://coveralls.io/repos/github/Greg-Rose/LFGamer/badge.svg?branch=master)](https://coveralls.io/github/Greg-Rose/LFGamer?branch=master)

A social networking site for gamers to find and connect with other people to play with.

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
```

#### Create .env file

1. Create a .env file in project root directory
2. Add to .env file:
  * RACK_ENV=development
  * PORT=3000

#### Setup external API for game data

1. Create a free account at https://api.igdb.com/signup
2. Get your API Credentials User Key from your account
3. Add user key to .env file:
  * IGDB_API_KEY=YOUR_USER_KEY_HERE

#### Setup AWS S3

1. Create an AWS account at https://aws.amazon.com/
2. Add your AWS credentials to .env file:
  * AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_HERE
  * AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY_HERE
3. Create an S3 bucket
4. Add your S3 bucket name to .env file:
  * S3_DEV_BUCKET=YOUR_BUCKET_NAME_HERE

If deploying to production, set bucket environment variable as S3_PRODUCTION_BUCKET=YOUR_PRODUCTION_BUCKET_NAME_HERE

#### Run Server

```bash
# Run application, by default starts at localhost:3000
$ rails s
```

Visit the site in your browser at localhost:3000.

#### Seed Database

To seed the database with games and consoles:

```bash
# Run rails console
$ rails c

# Run initial seed
$ PropagateDatabase.initial_seed
```

#### Admins

To give a user admin status and/or try out admin functionality:

```bash
# Run rails console
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
$ npm install -g phantomjs-prebuilt

# Run JS tests
$ rspec . -t js:true

# Run all tests
$ rspec
```
