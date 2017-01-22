# frozen_string_literal: true
# Inserted with hooks to avoid uninitialized constant errors.
require 'i18n'
require 'rqrcode'

module Devise
  module RegistrationsControllerExtensions
    def self.prepended(base)
      base.class_eval do
        helper_method :two_factor_authentication_enabled?,
                      :two_factor_authentication_qr_code_uri,
                      :two_factor_authentication_secret
      end
    end

    def update_resource(resource, _params)
      result = super
      toggle_two_factor_authentication(resource) if result
      result
    end

    protected

    # View helpers

    def two_factor_authentication_enabled?(user = resource)
      RoseQuartz::UserAuthenticator.exists? user_id: user.id
    end

    def two_factor_authentication_qr_code_uri(size:)
      uri = new_authenticator.provisioning_uri
      qr = RQRCode::QRCode.new(uri)
      qr.as_png(size: size).to_data_url
    end

    def two_factor_authentication_secret
      new_authenticator.secret
    end

    private

    # Internal logic

    def toggle_two_factor_authentication(resource)
      if two_factor_authentication_enabled?
        disable_two_factor_authentication!(resource) if form_params[:disable]
      else
        enable_two_factor_authentication!(resource)
      end
    end

    def disable_two_factor_authentication!(resource)
      RoseQuartz::UserAuthenticator.find_by(user_id: resource.id).disable!
    end

    def enable_two_factor_authentication!(resource)
      secret, token = form_params.values_at(:secret, :token)
      authenticator = RoseQuartz::UserAuthenticator.new(user: resource, secret: secret)
      token_valid = authenticator.authenticate(token) rescue false
      if token_valid
        authenticator.save
      else
        resource.errors.add(:base, I18n.t('rose_quartz.errors.enable_tfa_invalid_token'))
      end
    end

    def form_params
      params.require(:two_factor_authentication).permit(:secret, :token, :disable)
    end

    def new_authenticator
      @authenticator ||= RoseQuartz::UserAuthenticator.new(user: resource)
    end
  end
end
