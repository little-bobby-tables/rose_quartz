# frozen_string_literal: true
require 'i18n'
require 'rqrcode'

module Devise
  module RegistrationsControllerExtensions
    def self.prepended(base)
      base.class_eval do
        helper_method :two_factor_authentication_enabled?,
                      :two_factor_authentication_backup_code,
                      :two_factor_authentication_qr_code_uri,
                      :two_factor_authentication_secret
      end
    end

    def update_resource(resource, _params)
      result = super
      edit_two_factor_authentication(resource) if result
      result
    end

    protected

    # View helpers

    def two_factor_authentication_enabled?(user = resource)
      RoseQuartz::UserAuthenticator.exists? user_id: user.id
    end

    def two_factor_authentication_backup_code
      authenticator(resource).backup_code
    end

    def two_factor_authentication_qr_code_uri(size:)
      uri = authenticator.provisioning_uri
      qr = RQRCode::QRCode.new(uri)
      qr.as_png(size: size).to_data_url
    end

    def two_factor_authentication_secret
      authenticator.secret
    end

    private

    # Internal logic

    def edit_two_factor_authentication(resource)
      if two_factor_authentication_enabled?
        disable_two_factor_authentication!(resource) if form_params[:disable] == '1'
        reset_two_factor_authentication_backup_code!(resource) if form_params[:reset_backup_code] == '1'
      else
        enable_two_factor_authentication!(resource)
      end
    end

    def disable_two_factor_authentication!(resource)
      authenticator(resource).disable!
    end

    def reset_two_factor_authentication_backup_code!(resource)
      authenticator(resource).reset_backup_code!
    end

    def enable_two_factor_authentication!(resource)
      secret, token = form_params.values_at(:secret, :token)
      authenticator = RoseQuartz::UserAuthenticator.new(user: resource, secret: secret)
      token_valid = authenticator.authenticate_otp!(token) rescue false
      if token_valid
        authenticator.save
      else
        resource.errors.add(:base, I18n.t('rose_quartz.invalid_token_when_enabling_tfa'))
      end
    end

    def form_params
      params.require(:two_factor_authentication).permit(:secret, :token, :disable, :reset_backup_code)
    end

    def authenticator(existing_user = nil)
      @authenticator ||= if existing_user
        RoseQuartz::UserAuthenticator.find_by(user_id: resource.id)
      else
        RoseQuartz::UserAuthenticator.new(user: resource)
      end
    end
  end
end
