# frozen_string_literal: true
require 'rotp'

module RoseQuartz
  class UserAuthenticator < ::ActiveRecord::Base
    belongs_to :user

    after_initialize :set_secret, if: :new_record?

    def set_secret
      self.secret ||= ROTP::Base32.random_base32
    end

    def totp
      @authenticator ||= ROTP::TOTP.new(secret, issuer: RoseQuartz.configuration.issuer)
    end

    def authenticate(token)
      authenticated_at = totp.verify_with_drift_and_prior(
          token, RoseQuartz.configuration.time_drift, last_authenticated_at)
      if authenticated_at
        update_columns last_authenticated_at: authenticated_at if persisted?
        true
      else
        false
      end
    end

    def provisioning_uri
      totp.provisioning_uri(user.send(RoseQuartz.configuration.user_identifier))
    end

    alias disable! delete
  end
end
