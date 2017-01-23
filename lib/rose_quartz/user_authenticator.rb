# frozen_string_literal: true
require 'rotp'

module RoseQuartz
  class UserAuthenticator < ::ActiveRecord::Base
    belongs_to :user

    after_initialize :set_secret_and_backup_code, if: :new_record?

    def set_secret_and_backup_code
      self.secret ||= ROTP::Base32.random_base32
      self.backup_code ||= generate_backup_code
    end

    def authenticate_otp!(token)
      authenticated_at = totp.verify_with_drift_and_prior(
          token, RoseQuartz.configuration.time_drift, last_authenticated_at)
      if authenticated_at
        update_columns last_authenticated_at: authenticated_at if persisted?
        true
      else
        false
      end
    end

    def authenticate_backup_code!(token)
      if token == backup_code
        reset_backup_code!
        true
      else
        false
      end
    end

    def reset_backup_code!
      update_columns backup_code: generate_backup_code
    end

    def totp
      @authenticator ||= ROTP::TOTP.new(secret, issuer: RoseQuartz.configuration.issuer)
    end

    def provisioning_uri
      totp.provisioning_uri(user.send(RoseQuartz.configuration.user_identifier))
    end

    alias disable! delete

    private

    # Four groups of 4-character base32 strings joined by dashes, e.g. "gs3w-ntpt-hrse-v23t"
    def generate_backup_code
      ROTP::Base32.random_base32(16).scan(/.{1,4}/).join('-')
    end
  end
end
