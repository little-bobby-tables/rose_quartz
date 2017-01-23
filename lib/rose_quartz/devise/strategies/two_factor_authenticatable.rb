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
        authenticator = RoseQuartz::UserAuthenticator.find_by(user_id: resource.id)
        token = params['otp']

        # Two-factor authentication is disabled
        return true if authenticator.nil?

        # Token is not provided
        return false if token.nil?

        # Token is a valid OTP
        return true if authenticator.authenticate_otp!(token)

        # Token is a valid backup code
        if authenticator.authenticate_backup_code!(token)
          env['rose_quartz.backup_code_used'] = true
          return true
        end

        # Token is not a valid OTP or backup code
        false
      end
    end
  end
end

Warden::Strategies.add(:two_factor_authenticatable, Devise::Strategies::TwoFactorAuthenticatable)
