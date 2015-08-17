require "spec_helper_models"
require "models/slugged"

class Blurg < ActiveRecord::Base
  include Slugged

  def slug_parts
    [name]
  end
end

describe Slugged do
  let(:blurg) { Blurg.new }

  it "derives the slug from the `slug_parts`" do
    blurg.name = "Ohai Dur!"
    blurg.derive_slug
    expect(blurg.slug).to eq "ohai-dur"
  end

  it "falls back to number count when out of slug_parts" do
    Blurg.create name: "Test Me"
    blurg.name = "Test Me"
    blurg.derive_slug
    expect(blurg.slug).to eq "test-me-2"
  end
end
