RoseQuartz.initialize! do |config|
  # Token issuer is used as a title in user applications (e.g. Google Authenticator).
  # It is included in the QR code, and changing it won't have an effect on users
  # that already have two-factor authentication enabled.
  config.issuer = 'My Rails Application'

  # In addition to +issuer+, client-side applications display an identifier
  # (usually, this is account's email address).
  # This setting needs to refer to an existing attribute or method of the authenticatable model.
  config.user_identifier = :email

  # Some users may have their devices slightly ahead or behind of the actual time.
  # To counter this, the authenticator will accept tokens that are generated for
  # timestamps withing the time drift window defined below.
  config.time_drift = 2.minutes
end
