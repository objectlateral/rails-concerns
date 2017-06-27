module Rails
  module Concerns
    class Railtie < Rails::Railtie
      initializer "concerns.autoload", before: :set_autoload_paths do |app|
        models_path = File.join File.dirname(__FILE__), "models"
        mailers_path = File.join File.dirname(__FILE__), "mailers"
        app.config.autoload_paths += [models_path, mailers_path]
      end
    end
  end
end
