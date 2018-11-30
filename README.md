# README

This repo samples code from my recent employer, and was constructed in a Rails framework and optimized for speed and serialization using a PostgreSQL database. The samples include RESTful controllers, a TDD spec suite, provisions and gems for security and password management, as well as a serialized API dependant on a few dozen associated models -- which together form the backbone of the API. Views were not relevant to our backend API, as it is one of several modular applications (including AWS and React) that together formed the alpha launch for Carbon Collective.

<b>Carbon Collective is an environmental startup launching the first web app for consolidated and holistic carbon foot-printing.first web app for consolidated and holistic carbon foot-printing.</b>

An example JSON return:
```
{
  id: 1,
  first: "Original",
  last: "User",
  email: "original.user@gmail.com",
  avatar_url: null,
  house_ids: [
    18
  ],
  total_carbon_savings_to_date: "288.12 kWhs",
  global_collective_carbon_savings: "8826.85 kWhs",
  privacy_policy: true,
  slug: "original-user-gmail-com",
  move_in_date: "2000-10-20T06:00:00.000Z",
  household: {
    id: 18,
    total_sq_ft: null,
    no_residents: 2,
    created_at: "2018-11-28T17:14:16.753Z",
    updated_at: "2018-11-28T17:14:16.789Z",
    address_id: 18,
    apartment: false,
    avg_daily_electricity_consumed_per_user: "0.0",
    avg_daily_water_consumed_per_user: "0.0",
    avg_daily_gas_consumed_per_user: "0.0",
    avg_daily_carbon_consumed_per_user: "0.0",
    total_electricity_consumed: "0.0",
    total_water_consumed: "0.0",
    total_gas_consumed: "0.0",
    total_carbon_consumed: "0.0",
    max_regional_avg_electricity_consumption: "0.0",
    max_regional_avg_water_consumption: "0.0",
    max_regional_avg_gas_consumption: "0.0",
    max_regional_avg_carbon_consumption: "0.0"
  },
  neighborhood: [
    59,
    "Gateway - Green Valley Ranch"
  ],
  city: [
    1,
    "Lansing"
  ],
  county: [
    17,
    "Ingham County"
  ],
  region: [
    6,
    "Michigan"
  ],
  country: [
    194,
    "United States of America"
  ],
  navbar_helper: {
    electricity: true,
    water: true,
    gas: true
  },
  checklists_left: 3,
  invites_left: 3,
  bills_left: 3,
  resources_entered: null
}
```

The JSON responses have been serialized, using ActiveModel::Serializers and the gem active_model_serializers.

Users have been slugged and most API endpoints depend on an incoming :slug for user identification instead of :id

The API has been versioned to allow for fluid future changes.

Responses have been cached using Rails cache.

* Ruby version 2.4.1p111

* System dependencies
  complete instructions here[https://gorails.com/setup/osx/10.13-high-sierra]

    mysql (installation instructions here[https://dev.mysql.com/doc/refman/5.5/en/osx-installation-pkg.html])

    ruby (installation instructions here[https://www.ruby-lang.org/en/documentation/installation/])

    rails (installation instructions here[http://blog.teamtreehouse.com/install-rails-5-mac])

* Additional Gems

  gem 'pg'
  gem 'active_model_serializers', '0.10.0'  
  gem 'aws-sdk-s3'
  gem 'friendly_id'
  gem 'sidekiq'
  gem 'sinatra'
  gem 'bcrypt'
  gem 'omniauth-facebook'
  gem 'figaro'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
  gem 'redis', '~> 3.0'
  gem 'newrelic_rpm'


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

  run
  ```shell
    rails s
  ```


===== ====== ====== ====== ====== ====== ====== ====== ===== ===== ===== ===== ===== ===== =====

## Endpoints

api resource list (all RESTful routes for each resource are available for CRUD and in can be seen in `routes`):

### Users (examples)
  * GET /api/v1/users
  * GET /api/v1/users/:id
  * GET /api/v1/users/:id/resources?resource=<resource_name>

  ```shell
    example: "GET 'localhost:3000/api/v1/users/example-user-slug/resource?resource=electricity'"
  ```

### Regions (examples)
  * GET /api/v1/areas/countries
  * GET /api/v1/areas/cities
  * GET /api/v1/areas/neighborhoods/:id
