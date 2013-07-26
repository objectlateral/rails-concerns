require "spec_helper"
require "models/encoded_id"

ActiveRecord::Migration.create_table :widgets do |t|
  t.string :name
  t.timestamps
end

class Widget < ActiveRecord::Base
  include EncodedId
end

describe EncodedId do
  let(:widget) { Widget.new }

  describe ".where_encoded_id" do
    it "raises record not found when decoded id is too large" do
      expect {
        Widget.where_encoded_id "2456789bcdfghjklmnpqrstvwxyz"
      }.to raise_error ActiveRecord::RecordNotFound
    end

    it "calls AR where method with decoded id" do
      # xyz => 20355 is known decode
      expect(Widget).to receive(:where).with id: 20355
      Widget.where_encoded_id "xyz"
    end
  end

  describe "#encoded_id" do
    it "returns the encoded id using the object's id" do
      widget.id = 20355
      expect(widget.encoded_id).to eq "xyz"
    end
  end

  describe EncodedId::IdEncoder do
    it "encodes an id integer into a string and decodes it back" do
      id = 321234334
      encoded = EncodedId::IdEncoder.encode id
      decoded = EncodedId::IdEncoder.decode encoded
      expect(decoded).to eq id
    end

    it "encodes an id string into a string and decodes it back to an integer" do
      id = "323"
      encoded = EncodedId::IdEncoder.encode id
      decoded = EncodedId::IdEncoder.decode encoded
      expect(decoded).to eq id.to_i
    end

    it "returns nil when decoding a string that has chars outside the keyset" do
      expect(EncodedId::IdEncoder.decode("123")).to be_nil
    end
  end
end
