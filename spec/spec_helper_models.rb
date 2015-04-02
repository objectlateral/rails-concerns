require "pry"
require "active_record"

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.create_table :people do |t|
  t.timestamps null: false
end

ActiveRecord::Migration.create_table :users do |t|
  t.string :encrypted_password
  t.timestamps null: false
end

ActiveRecord::Migration.create_table :widgets do |t|
  t.string :name
  t.string :slug
  t.string :access_token
  t.timestamps null: false
end

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
