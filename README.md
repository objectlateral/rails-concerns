# Rails::Concerns

Common concerns (modules) to be mixed in to Rails models and controllers

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

    class Person < ActiveRecord::Base
      include EncodedId
    end

    paul = Person.create name: "Paul"
    paul.id # => 20355
    paul.encoded_id # => "xyz"
    Person.where_encoded_id("xyz").first.name => "Paul"


## Mailer Concerns Included

## ResquedDelivery

Makes any `ActionMailer::Base` subclass transparently send its mail via Resque.

    class OrderMailer < ActionMailer::Base
      include ResquedDelivery

      def confirmation order_id
        @order = Order.find order_id
        mail to: @order.email
      end
    end

    OrderMailer.confirmation(3).deliver # => queued in Resque

Note: this concern is short-circuited in `Rails.env.test` so you can confirm email is sent like normal
