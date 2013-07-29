require "bcrypt"

module PasswordAuth
  def self.included base
    if base.columns.map(&:name).exclude? "encrypted_password"
      raise NotImplementedError, "model must have 'encrypted_password' column"
    end
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
  end
end
