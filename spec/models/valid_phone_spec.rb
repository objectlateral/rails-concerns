require "spec_helper_models"
require "models/valid_phone"

class User < ActiveRecord::Base
  include ValidPhone

  valid_phone :cell_phone
  valid_phone :home_phone, allow_blank: true
end

describe ValidPhone do
  let(:user) { User.new }

  it "validates format to 10 required digits" do
    user.cell_phone = "867 5309"
    expect(user).not_to be_valid
    user.cell_phone = "4028675309"
    expect(user).to be_valid
    user.cell_phone = "+1 5052369443"
    expect(user).to be_valid
  end

  it "validates format on blankable attr as well" do
    user.cell_phone = "4028675309"
    user.home_phone = "oh noes!"
    expect(user).not_to be_valid
    user.home_phone = "4028675309"
    expect(user).to be_valid
  end

  it "sanitizes before validating" do
    user.cell_phone = "402 867 5309"
    expect(user).to be_valid
    expect(user.cell_phone).to eq "4028675309"
  end

  it "classifies upon request" do
    user.cell_phone = "4028675309"
    user.home_phone = "402-867-5309"
    expect(user.classy_cell_phone).to eq "(402) 867-5309"
    expect(user.classy_home_phone).to eq "(402) 867-5309"
  end
end
