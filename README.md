# RoseQuartz

[![Build Status](https://travis-ci.org/little-bobby-tables/rose_quartz.svg?branch=master)](https://travis-ci.org/little-bobby-tables/rose_quartz)
[![Test Coverage](https://codeclimate.com/github/little-bobby-tables/rose_quartz/badges/coverage.svg)](https://codeclimate.com/github/little-bobby-tables/rose_quartz/coverage)

A gem that adds two-factor authentication (time-based one-time passwords) to [Devise](https://github.com/plataformatec/devise) 
using the [rotp](https://github.com/mdp/rotp) library.

It attempts to stay lightweight by making a lot of assumptions — for example, that 
you have a single authenticatable resource, `User`, and that you're using `ActiveRecord`.

Highlights of *RoseQuartz* are:

* Zero tampering with the `User` model — no additional fields, no included modules.
* Separate table that can be updated in future without affecting your codebase and data.
* Built with Rails 5 and Devise 4 in mind.

What it does not do:

* Use a multiple-page login system (email and password first, two-factor authentication token next).
It introduces lots of needless complexity, which goes against the purpose of this gem.
* Encrypt the secret used to generate OTP. You can find other solutions that do.
* Provide backup codes. This is something I'm actively working on.

## Getting Started

First, add *RoseQuartz* to your Gemfile:

```
gem 'rose_quartz'
```
And run:
```
bundle install
```

Next, you need to copy initializers, locales, and add a migration:
```
rails g rose_quarts:install
```

Finally, run the migration:
```
rails db:migrate
```

## Adding views

#### Signing in

You need a special field for one-time password on the sign-in page (*app/views/devise/sessions/new.html.erb*).
Since it is always present, you might want to make it obvious that it is only required to be filled
when the user has two-factor authentication enabled.

Here's an example:

```
<%# E-mail and password fields %>

<div class="field">
  <%= label_tag :otp, 'Two-factor authentication token' %>
  <%= text_field_tag :otp, '', autocomplete: "off" %>
</div>

<%# The rest of the form %>
```

Note that you must leave the parameter name (`otp`) intact.

#### Enabling/disabling two-factor authentication

The gem adds a special extension to Devise that allows you to 
include two-factor authentication setup in the account editing page
(*app/views/devise/registrations/edit.html.erb*).

As with other settings there, a password is required to toggle two-factor authentication.
The user also needs to provide a correct token generated by their TOTP application of choice, 
which ensures that their device clock is in sync with the server.

Here's a sample implementation:

```
<div class="field">
  <%= fields_for :two_factor_authentication do |tfa| %>
    <% if two_factor_authentication_enabled? %>
      <%= tfa.label :disable, 'Disable two-factor authentication' %>
      <%= tfa.check_box :disable %>
    <% else %>
      <%= tfa.hidden_field :secret, value: two_factor_authentication_secret %>
      <%= image_tag two_factor_authentication_qr_code_uri(size: 200) %>
      <p>
        Scan this QR code with your device and enter the token below:
      </p>
      <%= tfa.label :token, 'Token' %><br />
      <%= tfa.text_field :token, value: '' %>
      <p>
        Tip: to configure authentication on multiple devices, scan the code using each device.
      </p>
    <% end %>
  <% end %>
</div>
```

The following helper methods are available in the view: `two_factor_authentication_enabled?`, 
`two_factor_authentication_qr_code_uri`, and `two_factor_authentication_secret`.
