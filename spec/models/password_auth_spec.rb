require "spec_helper_models"
require "rails/concerns/helpers"
require "models/password_auth"

class User < ActiveRecord::Base
  include PasswordAuth
end

class Person < ActiveRecord::Base; end

describe PasswordAuth do
  let(:user) { User.new }

  it "raises when included into a class w/ no encrypted_password attr" do
    expect {
      Person.send :include, PasswordAuth
    }.to raise_error NotImplementedError
  end

  describe "setting the password" do
    it "sets the encrypted_password attr using the given password" do
      expect(user).to receive(:encrypted_password=)
      user.password = "test1234"
    end

    it "does nothing when password is empty" do
      expect(user).to_not receive(:encrypted_password=)
      user.password = ""
    end
  end

  describe "authenticating" do
    before do
      user.password = "test1234"
    end

    it "returns the user when authentication succeeds" do
      expect(user.authenticate("test1234")).to eq user
    end

    it "returns false when authentication fails" do
      user.password = "test1234"
      expect(user.authenticate("test4321")).to be false
    end

    it "returns false when encrypted_password is empty" do
      user.encrypted_password = nil
      expect(user.authenticate("test4321")).to be false
    end
  end
end
