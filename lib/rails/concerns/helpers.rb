module Rails
  module Concerns
    module Helpers
      def require_column base, column_name
        return if migrations_pending? base

        if base.table_exists? and base.columns.map(&:name).exclude?(column_name)
          raise NotImplementedError, "#{base} must have '#{column_name}' column"
        end
      end

      private

      def migrations_pending? base
        if ActiveRecord::Migrator.respond_to? :needs_migration?
          ActiveRecord::Migrator.needs_migration?
        else
          base.connection.migration_context.needs_migration?
        end
      end
    end
  end
end
