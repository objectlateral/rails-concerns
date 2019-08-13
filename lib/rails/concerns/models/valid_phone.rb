module ValidPhone
  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def valid_phone attribute, options={}
      validation_options = {format: /\A\d{10,11}\Z/}.merge options
      validates attribute, validation_options
      before_validation "sanitize_#{attribute}".to_sym

      define_method "classy_#{attribute}" do
        phone = self[attribute]
        return "" if phone.blank?
        PhoneConverter.new(phone).classy
      end

      define_method "sanitize_#{attribute}" do
        phone = self[attribute]
        self[attribute] = PhoneConverter.new(phone).sanitized
      end
    end
  end

  class PhoneConverter
    attr_reader :original

    def initialize original
      @original = original || ""
    end

    def classy
      phone = sans_country
      "(#{phone[0..2]}) #{phone[3..5]}-#{phone[6..9]}"
    end

    def sans_country
      sanitized[-10, 10]
    end

    def sanitized
      return original if original.empty?
      digits_only = original.strip.gsub /\D/, ""
      # we can't leave this as an empty string because it'll pass validation
      # for non-required attributes, but it was set to an invalid value
      digits_only.empty? ? "invalid" : digits_only
    end
  end
end
