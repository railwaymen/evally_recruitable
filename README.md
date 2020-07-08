# Evally Recruitable ![version](https://img.shields.io/badge/version-0.1-blue) [![Build Status](https://travis-ci.com/railwaymen/evally.svg?branch=master)](https://travis-ci.com/railwaymen/evally) ![coverage](https://img.shields.io/badge/coverage-100%25-success)
An extension for Evally to manage and evaluate recruitment applications.

[![forthebadge](http://forthebadge.com/images/badges/made-with-ruby.svg)](http://forthebadge.com)

## Table of Contents
- [Features](#features)
- [Requirements](#requirements)
- [Instalation](#instalation)
- [Feedback](#feedback)
- [Contributing](#contributing)
- [License](#license)

## Features
Some things you can do with this extension:
- list all recruitment applications with simple filters and search field
- present necessary information in a straight way
- upload and store attachments
- mark recruitment applications with statuses
- assign evaluators to candidate
- evaluate documents based on customized templates
- add comments to candidate's profile

## Requirements

- Ruby 2.7.0
- PostgreSQL 10.6+
- Docker

## Instalation

##### 1. Pull the repository

```bash
git clone https://github.com/railwaymen/evally_recruitable.git
```

##### 2. Install application dependencies

Run the following commands to install all required dependencies.

```bash
bundle install
```


##### 3. Update seeds.rb file

Update db/seeds.rb file to provide credentials for user who will be created during database setup (look at next step).

```ruby
User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'password'
  u.first_name = 'John'
  u.last_name = 'Doe'
  u.role = 'admin'
end
```

**Important!** First admin user must be identical as in Evally core module.

##### 4. Create and setup the database

Run the following commands to create and setup the database.

```bash
bundle exec rake db:create
bundle exec rake db:setup
```

##### 5. Run Sidekiq
Run Sidekiq for background jobs processing. It is important to provide data synchronization between core module and extensions.

```bash
# run sidekiq
bundle exec sidekiq
```

##### 6. Start the Rails server

You can start the development rails server in the way given below:

```bash
# run rails server
bundle exec rails s -p 3030
```


## Feedback

Feel free to send us feedback. Feature requests are always welcome. If you wish to contribute, please take a quick look at the guidelines!

If you notice any bugs in the app, see some code that can be improved, or have features you would like to be added, please create a bug report or a feature request!

A good bug report must include the following four things:

1. **The steps to reproduce the bug**: Give detailed steps on how to reproduce the problem
2. **The expected behavior of the application**: It’s important to include the result you’re expecting, as it might differ from how the program was designed to work.
3. **The observed behavior of the application**
4. **Additional info**: ... like some links, images etc.

## Contributing

We encourage you to contribute to Evally! See [CONTRIBUTING](CONTRIBUTING.md) for guidelines about how to proceed.

Thank you for your interest in contributing! Please feel free to put up a PR for any issue or feature request.

If you want to open a PR that fixes a bug or adds a feature, then we can't thank you enough! It is definitely appreciated if an issue has been created before-hand so it can be discussed first.

## License

Evally Recruitable is released under the *GNU GPL* license.
