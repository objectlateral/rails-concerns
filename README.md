# Rails::Concerns [![Code Climate](https://codeclimate.com/github/objectlateral/rails-concerns.png)][cc]

Common concerns (modules) to be mixed in to Rails models, controllers, and mailers.

## Installation

Add this line to your application's Gemfile:

    gem "rails-concerns", github: "objectlateral/rails-concerns"

And then execute:

    $ bundle

## Usage

Just `include` the modules that your Rails models or controllers are concerned with.

## Model Concerns Included

### EncodedId

Provides human readable unique strings using each model's `id` attribute. Great for short URLs. Usage:

```ruby
class Person < ActiveRecord::Base
  include EncodedId
end

paul = Person.create name: "Paul"
paul.id # => 20355
paul.encoded_id # => "xyz"
Person.where_encoded_id("xyz").first.name => "Paul"
```

### PasswordAuth

Provides basic password setting and authenticating via [bcrypt][bcrypt]. Including models must have an `encrypted_password` attribute.

```ruby
class User < ActiveRecord::Base
  include PasswordAUth
end

user = User.new password: "test1234"
user.authenticate "test1234" # => user object
user.authenticate "test4321" # => false
```

### TokenizedAttributes

Provides easy generation of random SHA tokens for a model's attributes.

```ruby
class Document < ActiveRecord::Base
  include TokenizedAttributes

  tokenize :slug
end

d = Document.create
d.slug # db89148af5c734ed8f34cb1402b699d63784591f
d.regenerate_token :slug
d.slug # cfa5946b9cb1abc80c02f050f383f06514fb70da
```

## Controller Concerns Included

### JsonRenderer

Adds convenience methods for rendering JSON from controllers

```ruby
class ThingsController < ApplicationController
  include JsonRenderer

  def index
    things = Thing.all
    ok things
  end

  def create
    thing = Thing.create params
    created thing
  end

  def destroy
    thing = Thing.find params[:id]
    thing.destroy
    no_content
  end

  # ... et cetera
end
```

[cc]:https://codeclimate.com/github/objectlateral/rails-concerns
[bcrypt]:https://github.com/codahale/bcrypt-ruby
