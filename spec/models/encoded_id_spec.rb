require "spec_helper_models"
require "models/encoded_id"

class Widget < ActiveRecord::Base
  include EncodedId
end

describe EncodedId do
  let(:widget) { Widget.new }

  describe "salt" do
    after do
      Widget.encoded_id_salt = nil
    end

    it "starts off as 'salty goodness'" do
      expect(Widget.id_encoder.salt).to eq "salty goodness"
    end

    it "can be changed to something else" do
      Widget.encoded_id_salt = "so so salty"
      expect(Widget.id_encoder.salt).to eq "so so salty"
    end
  end

  describe "minimum length" do
    after do
      Widget.encoded_id_min_length = nil
    end

    it "starts off as 0" do
      expect(Widget.id_encoder.min_length).to eq 0
    end

    it "can be changed to something else" do
      Widget.encoded_id_min_length = 8
      expect(Widget.id_encoder.min_length).to eq 8
    end
  end

  describe ".find_by_encoded_id" do
    it "calls AR .find_by with nil when passed nil" do
      expect(Widget).to receive(:find_by).with id: nil
      Widget.find_by_encoded_id nil
    end

    it "calls AR .find_by with decoded id" do
      # endk6x8 => 10_000_000 is known decode
      expect(Widget).to receive(:find_by).with id: 10_000_000
      Widget.find_by_encoded_id "endk6x8"
    end

    it "raises AR error when passed invalid hash" do
      expect {
        Widget.find_by_encoded_id "browserconfig.xml"
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe ".find_by_encoded_id!" do
    it "calls AR .find_by! with nil when passed nil" do
      expect(Widget).to receive(:find_by!).with id: nil
      Widget.find_by_encoded_id! nil
    end

    it "calls AR .find_by with decoded id" do
      expect(Widget).to receive(:find_by).with id: 10_000_000
      Widget.find_by_encoded_id "endk6x8"
    end

    it "raises AR error when passed invalid hash" do
      expect {
        Widget.find_by_encoded_id "browserconfig.xml"
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe ".where_encoded_id" do
    it "calls AR .where with nil when passed nil" do
      expect(Widget).to receive(:where).with id: nil
      Widget.where_encoded_id nil
    end

    it "calls AR .where with decoded id" do
      expect(Widget).to receive(:where).with id: 10_000_000
      Widget.where_encoded_id "endk6x8"
    end

    it "raises AR error when passed invalid hash" do
      expect {
        Widget.where_encoded_id "browserconfig.xml"
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "#encoded_id" do
    it "returns the encoded id using the object's id" do
      widget.id = 10_000_000
      expect(widget.encoded_id).to eq "endk6x8"
    end
  end
end
