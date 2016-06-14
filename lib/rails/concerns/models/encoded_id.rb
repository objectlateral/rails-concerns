require "hashids"

module EncodedId
  class IdEncoder
    attr_reader :hashids, :salt, :min_length
    def initialize salt, min_length
      @salt = salt
      @min_length = min_length
    end

    def hashids
      Hashids.new salt, min_length, "23456789abcdefghjkmnpqrstuvwxyz"
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
    def encoded_id_salt
      @encoded_id_salt || "salty goodness"
    end

    def encoded_id_min_length
      @encoded_id_min_length || 0
    end

    def encoded_id_min_length= length
      @encoded_id_min_length = length
    end

    def encoded_id_salt= salt
      @encoded_id_salt = salt
    end

    def id_encoder
      IdEncoder.new encoded_id_salt, encoded_id_min_length
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
