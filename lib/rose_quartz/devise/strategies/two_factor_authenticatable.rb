# frozen_string_literal: true
require 'devise/strategies/database_authenticatable'

module Devise
  module Strategies
    class TwoFactorAuthenticatable < ::Devise::Strategies::DatabaseAuthenticatable
      def authenticate!
        resource = password.present? && mapping.to.find_for_database_authentication(authentication_hash)

        super if validate(resource) { otp_matches?(resource) }
      end

      def otp_matches?(resource)
        authenticator = RoseQuartz::UserAuthenticator.find_by(user_id: resource.id)
        return true if authenticator.nil? # two-factor authentication is disabled

        token = params['otp']
        return false if token.nil?

        authenticator.authenticate(token)
      end
    end
  end
end

Warden::Strategies.add(:two_factor_authenticatable, Devise::Strategies::TwoFactorAuthenticatable)
