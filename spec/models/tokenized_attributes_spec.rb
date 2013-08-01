require "spec_helper_models"
require "models/tokenized_attributes"

class Widget < ActiveRecord::Base
  include TokenizedAttributes
end

describe TokenizedAttributes do
  describe ".tokenize" do
    it "adds the attributes and options to the list of tokenized attributes" do
      Widget.tokenize :slug
      expect(Widget.tokenized_attributes[:slug]).to eq auto: true
      Widget.tokenize :access_token, auto: false
      expect(Widget.tokenized_attributes[:access_token]).to eq auto: false
      expect(Widget.tokenized_attributes.length).to eq 2
    end
  end

  describe "generating token on create" do
    it "does so when auto is true (default)" do
      Widget.tokenize :slug
      w = Widget.create
      expect(w.slug).to_not be_nil
    end

    it "doesn't do so when auto is false" do
      Widget.tokenize :slug, auto: false
      w = Widget.create
      expect(w.slug).to be_nil
    end
  end

  describe "regenerate_token" do
    it "regenerates the given token and saves the object" do
      Widget.tokenize :slug
      w = Widget.create
      before_regen = w.slug
      w.regenerate_token :slug
      expect(w).to_not be_changed
      expect(w.slug).to_not eq before_regen
    end
  end
end
