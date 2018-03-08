# README

This project, is a RESTful public  API built in the Rails framework for delivering user biking and travelling data, in order to calculate total carbon footprint (CO2) savings. Current resources include:

* USERS
* GROUPS
* DAYS
* TRIPS

The JSON responses have been serialized, using ActiveModel::Serializers and the gem active_model_serializers.

Responses have been cached using Rails cache.

Data is populated by first downloading a schema and dataset from a fellow github user kind enough to supply it, as well as several different datasets from the Faker gem -- then this vehicle_api functions as the webserver spitting out json responses to restful requests.

Makes are linked to models, and vehicles inherit from model and make; Vehicles also can be 'purchased' with options, or options added on later. Visit the API endpoints (bottom of README or at http://localhost:3000) after setting up the project (below) for further explication.

* Ruby version 2.4.1p111

* System dependencies
  complete instructions here[https://gorails.com/setup/osx/10.13-high-sierra]

    mysql (installation instructions here[https://dev.mysql.com/doc/refman/5.5/en/osx-installation-pkg.html])

    ruby (installation instructions here[https://www.ruby-lang.org/en/documentation/installation/])

    rails (installation instructions here[http://blog.teamtreehouse.com/install-rails-5-mac])

* Additional Gems

  gem 'pg'

  gem 'active_model_serializers', '0.10.0'

  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'




## Deployment instructions

  clone repo and cd into it

  run
  ```shell
    gem install bundle
    bundle install
    rake db:drop
    rake db:create
    rake db:migrate
  ```

#### then, import fake user data using `rake db:seed` and you're ready to go!


===== ====== ====== ====== ====== ====== ====== ====== ===== ===== ===== ===== ===== ===== =====

## Endpoints

api resource list (all RESTful routes for each resource are available for CRUD):

### Users
  * GET /api/v1/users
  * GET /api/v1/users/:id

  ```shell
  users attributes:
    company: string, must be unique
    company_desc: string, must be unique
    company_motto: string,
    ceo_statement: string

  example:
    GET http://localhost:3000/api/v1/makes

  ```

### Groups
  * GET /api/v1/groups
  * GET /api/v1/groups/:id
  * GET /api/v1/users/:id/groups

### Trips
  * GET /api/v1/trips
  * GET /api/v1/users/:id/trips

### Days
  * GET /api/v1/days
  * GET /api/v1/days/:id
  * GET /api/v1/days/:id/trips
