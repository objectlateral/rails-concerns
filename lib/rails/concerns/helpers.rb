module Rails
  module Concerns
    module Helpers
      def require_column base, column_name
        return if ActiveRecord::Migrator.needs_migration?

        if base.table_exists? and base.columns.map(&:name).exclude?(column_name)
          raise NotImplementedError, "#{base} must have '#{column_name}' column"
        end
      end
    end
  end
end
