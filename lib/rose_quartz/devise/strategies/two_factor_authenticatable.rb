# frozen_string_literal: true
require 'devise/strategies/database_authenticatable'

module Devise
  module Strategies
    class TwoFactorAuthenticatable < ::Devise::Strategies::DatabaseAuthenticatable
      def authenticate!
        resource = password.present? && mapping.to.find_for_database_authentication(authentication_hash)

        super if validate(resource) { authenticated?(resource) }
      end

      def authenticated?(resource)
        @authenticator = RoseQuartz::UserAuthenticator.find_by(user_id: resource.id)
        token = params['otp']

        # Two-factor authentication is disabled
        return true if @authenticator.nil?

        # OTP or backup code is not present
        return false if token.nil?

        @authenticator.authenticate_otp!(token) || @authenticator.valid_backup_code?(token)
      end
    end
  end
end

Warden::Strategies.add(:two_factor_authenticatable, Devise::Strategies::TwoFactorAuthenticatable)
