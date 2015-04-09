require "hashids"

module EncodedId
  def self.included base
    base.extend ClassMethods
  end

  def encoded_id
    self.class.id_encoder.encode id
  end

  module ClassMethods
    def id_encoder_salt
      @id_encoder_salt || "salty goodness"
    end

    def id_encoder_salt= salt
      @id_encoder_salt = salt
    end

    def id_encoder
      Hashids.new id_encoder_salt, 0, "23456789abcdefghjkmnpqrstuvwxyz"
    end

    def where_encoded_id id
      decoded = id_encoder.decode(id).first
      where id: decoded
    rescue Hashids::InputError
      raise ActiveRecord::RecordNotFound
    end
  end
end
