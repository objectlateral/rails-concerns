module TokenizedAttributes
  def self.included base
    base.before_create :generate_tokens
    base.extend ClassMethods
  end

  module ClassMethods
    def tokenize *args
      options = {
        auto: true # autogenerate on create
      }

      if args.last.is_a? Hash
        options.merge! args.pop
      end

      @tokenized_attributes ||= {}

      args.each do |arg|
        @tokenized_attributes[arg.to_sym] = options
      end
    end

    def tokenized_attributes
      @tokenized_attributes
    end
  end

  def generate_unique_token
    Digest::SHA1.hexdigest (Time.now.usec.to_s + attributes.inspect)
  end

  def regenerate_token attribute
    set_token_for_attribute attribute
    save!
  end

  private

  def generate_tokens
    self.class.tokenized_attributes.each do |attr,options|
      if options[:auto]
        set_token_for_attribute attr
      end
    end
  end

  def set_token_for_attribute attr
    self.send "#{attr.to_s}=", generate_unique_token
  end
end
