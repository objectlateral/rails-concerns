module EncodedId
  def self.included base
    base.extend ClassMethods
  end

  def encoded_id
    @encoded_id ||= IdEncoder.encode id
  end

  module ClassMethods
    def where_encoded_id id
      decoded = IdEncoder.decode id
      raise ActiveRecord::RecordNotFound if (decoded && decoded > 2147483647)
      where id: decoded
    end
  end

  class IdEncoder
    KEYSET = "2456789bcdfghjklmnpqrstvwxyz"

    ENCODER = Hash[KEYSET.chars.map.with_index.to_a.map(&:reverse)]
    DECODER = Hash[KEYSET.chars.map.with_index.to_a]

    def self.encode id
      id = id.to_i

      result = []
      base = KEYSET.length

      while id != 0
        result << ENCODER[id % base]
        id /= base
      end

      result.reverse.join
    end

    def self.decode string
      base = KEYSET.length

      string.reverse.chars.to_enum.with_index.inject(0) do |sum, (char, i)|
        if match = DECODER[char]
          sum + match * base ** i
        else
          return nil
        end
      end
    end
  end
end
