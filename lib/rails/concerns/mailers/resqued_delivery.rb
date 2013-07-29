module ResquedDelivery
  def self.included base
    base.instance_variable_set :@queue, :email
    base.extend ClassMethods
  end

  module ClassMethods
    def perform action, *args
      self.send(:new, action, *args).message.deliver!
    end

    def method_missing method_name, *args
      return super if Rails.env.test? || action_methods.exclude?(method_name.to_s)

      worker = self

      super.tap do |mail_message|
        mail_message.class_eval do
          define_method :deliver do
            Resque.enqueue worker, method_name, *args
          end
        end
      end
    end
  end
end
