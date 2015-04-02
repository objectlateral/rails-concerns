require "spec_helper_models"
require "models/encoded_id"

class Widget < ActiveRecord::Base
  include EncodedId
end

describe EncodedId do
  let(:widget) { Widget.new }

  describe "salt" do
    after do
      Widget.id_encoder_salt = nil
    end

    it "starts off as 'salty goodness'" do
      expect(Widget.id_encoder.salt).to eq "salty goodness"
    end

    it "can be changed to something else" do
      Widget.id_encoder_salt = "so so salty"
      expect(Widget.id_encoder.salt).to eq "so so salty"
    end
  end

  describe ".where_encoded_id" do
    it "calls AR where method with decoded id" do
      # endk6x8 => 10_000_000 is known decode
      expect(Widget).to receive(:where).with id: 10_000_000
      Widget.where_encoded_id "endk6x8"
    end
  end

  describe "#encoded_id" do
    it "returns the encoded id using the object's id" do
      widget.id = 10_000_000
      expect(widget.encoded_id).to eq "endk6x8"
    end
  end
end
