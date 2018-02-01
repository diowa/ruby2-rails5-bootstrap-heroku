# Rails 5 Starter App
[![Build Status](https://travis-ci.org/diowa/ruby2-rails5-bootstrap-heroku.svg?branch=master)](https://travis-ci.org/diowa/ruby2-rails5-bootstrap-heroku)
[![Code Climate](https://codeclimate.com/github/diowa/ruby2-rails5-bootstrap-heroku/badges/gpa.svg)](https://codeclimate.com/github/diowa/ruby2-rails5-bootstrap-heroku)
[![Coverage Status](https://coveralls.io/repos/github/diowa/ruby2-rails5-bootstrap-heroku/badge.svg?branch=master)](https://coveralls.io/github/diowa/ruby2-rails5-bootstrap-heroku?branch=master)

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Unstable - we are currently force pushing commits on master branch

This is a starter web application based on the following technology stack:

* [Ruby 2.5.1][1]
* [Rails 5.2.0][2]
* [Webpack][15]
* [Yarn][16]
* [Puma][3]
* [PostgreSQL][4]
* [RSpec][5]
* [PhantomJS][6] + [Poltergeist][7]
* [Bootstrap 4.1.1][8]
* [Autoprefixer][9]
* [Font Awesome 5.1.0-11 SVG][10]
* [Slim][11]
* [RuboCop][12]
* [RuboCop RSpec][17]
* [Slim-Lint][13]
* [stylelint][14]

[1]: https://www.ruby-lang.org/en/
[2]: http://rubyonrails.org/
[3]: https://puma.io/
[4]: https://www.postgresql.org/
[5]: https://rspec.info/
[6]: https://github.com/ariya/phantomjs/
[7]: https://github.com/teampoltergeist/poltergeist
[8]: https://getbootstrap.com/
[9]: https://github.com/postcss/autoprefixer
[10]: https://fontawesome.com/
[11]: http://slim-lang.com/
[12]: https://github.com/bbatsov/rubocop
[13]: https://github.com/sds/slim-lint
[14]: https://stylelint.io/
[15]: https://webpack.js.org/
[16]: https://yarnpkg.com/lang/en/
[17]: https://github.com/backus/rubocop-rspec

Starter App is deployable on [Heroku](https://www.heroku.com/). Demo: https://ruby2-rails5-bootstrap-heroku.herokuapp.com/

```Gemfile``` also contains a set of useful gems for performance, security, api building...

### Thread safety

We assume that this application is thread safe. If your application is not thread safe or you don't know, please set the minimum and maximum number of threads usable by puma on Heroku to 1:

```sh
$ heroku config:set RAILS_MAX_THREADS=1
```

### Master Key

Rails 5.2 introduced [encrypted credentials](http://edgeguides.rubyonrails.org/5_2_release_notes.html#credentials).

The master key used by this repository is:

```
b8cc3ac9ab8a3280b03af3d29b2e50ca
```

**DO NOT SHARE YOUR MASTER KEY. CHANGE THIS MASTER KEY IF YOU ARE GOING TO USE THIS REPO FOR YOUR OWN PROJECT.**

### Heroku Platform API

This application supports fast setup and deploy via [app.json](https://devcenter.heroku.com/articles/app-json-schema):

```sh
$ curl -n -X POST https://api.heroku.com/app-setups \
-H "Content-Type:application/json" \
-H "Accept:application/vnd.heroku+json; version=3" \
-d '{"source_blob": { "url":"https://github.com/diowa/ruby2-rails5-bootstrap-heroku/tarball/master/"} }'
```

More information: [Setting Up Apps using the Platform API](https://devcenter.heroku.com/articles/setting-up-apps-using-the-heroku-platform-api)

### Recommended add-ons

Heroku's [Production Check](https://blog.heroku.com/introducing_production_check) recommends the use of the following add-ons, here in the free version:

```sh
$ heroku addons:create newrelic:wayne # App monitoring
$ heroku config:set NEW_RELIC_APP_NAME="Rails 5 Starter App" # Set newrelic app name
$ heroku addons:create papertrail:choklad # Log monitoring
```

### Tuning Ruby's RGenGC

Generational GC (called RGenGC) was introduced from Ruby 2.1.0. RGenGC reduces marking time dramatically (about x10 faster). However, RGenGC introduce huge memory consumption. This problem has impact especially for small memory machines.

Ruby 2.1.1 introduced new environment variable RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR to control full GC timing. By setting this variable to a value lower than the default of 2 (we are using the suggested value of 1.3) you can indirectly force the garbage collector to perform more major GCs, which reduces heap growth.

```sh
$ heroku config:set RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.3
```

More information: [Change the full GC timing](https://bugs.ruby-lang.org/issues/9607)
