module Rails
  module Concerns
    class Railtie < Rails::Railtie
      initializer "concerns.autoload", before: :set_autoload_paths do |app|
        concerns_root = File.dirname __FILE__
        app.config.autoload_paths << File.join(concerns_root, "models")
      end
    end
  end
end
