# frozen_string_literal: true
# Inserted with hooks to avoid uninitialized constant errors.
require 'i18n'
require 'rqrcode'

module Devise
  module RegistrationsControllerExtensions
    def self.prepended(base)
      base.class_eval do
        helper_method :tfa_enabled?, :tfa_qr_code_data_uri, :tfa_secret
      end
    end

    def update_resource(resource, _params)
      result = super
      toggle_tfa(resource) if result
      result
    end

    protected

    # View helpers

    def tfa_enabled?(user = resource)
      RoseQuartz::UserAuthenticator.exists? user_id: user.id
    end

    def tfa_qr_code_data_uri(size:)
      uri = new_authenticator.provisioning_uri
      qr = RQRCode::QRCode.new(uri)
      qr.as_png(size: size).to_data_url
    end

    def tfa_secret
      new_authenticator.secret
    end

    private

    # Internal logic

    def toggle_tfa(resource)
      if tfa_enabled?
        disable_tfa!(resource) if tfa_params[:disable_tfa]
      else
        enable_tfa!(resource)
      end
    end

    def disable_tfa!(resource)
      RoseQuartz::UserAuthenticator.find_by(user_id: resource.id).disable!
    end

    def enable_tfa!(resource)
      secret, token = tfa_params.values_at(:secret, :token)
      authenticator = RoseQuartz::UserAuthenticator.new(user: resource, secret: secret)
      token_valid = authenticator.authenticate(token) rescue false
      if token_valid
        authenticator.save
      else
        resource.errors.add(:base, I18n.t('rose_quartz.errors.enable_tfa_invalid_token'))
      end
    end

    def tfa_params
      params.require(:tfa).permit(:secret, :token, :disable_tfa)
    end

    def new_authenticator
      @authenticator ||= RoseQuartz::UserAuthenticator.new(user: resource)
    end
  end
end
