require "hashids"

module EncodedId
  class IdEncoder
    attr_reader :hashids, :salt
    def initialize salt
      @salt = salt
      @hashids = Hashids.new @salt, 0, "23456789abcdefghjkmnpqrstuvwxyz"
    end

    def encode id
      hashids.encode id
    end

    def decode id
      hashids.decode(id).first
    rescue Hashids::InputError
      raise ActiveRecord::RecordNotFound
    end
  end

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
      IdEncoder.new id_encoder_salt
    end

    def find_by_encoded_id id
      find_by id: id_encoder.decode(id)
    end

    def find_by_encoded_id! id
      find_by! id: id_encoder.decode(id)
    end

    def where_encoded_id id
      where id: id_encoder.decode(id)
    end
  end
end
