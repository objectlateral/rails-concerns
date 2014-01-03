require "bcrypt"

module PasswordAuth
  extend Rails::Concerns::Helpers

  def self.included base
    require_column base, "encrypted_password"
  end

  def password= unencrypted_password
    if unencrypted_password.present?
      self.encrypted_password = BCrypt::Password.create unencrypted_password
    end
  end

  def authenticate unencrypted_password
    if BCrypt::Password.new(encrypted_password) == unencrypted_password
      self
    else
      false
    end
  rescue BCrypt::Errors::InvalidHash
    false
  end
end
