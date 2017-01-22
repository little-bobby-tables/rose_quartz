FactoryGirl.define do
  factory :user do
    name 'user'
    email 'user@example.com'
    password 'correcthorsebatterystaple'

    factory :user_with_tfa do
      after(:create) do |inst|
        RoseQuartz::UserAuthenticator.create! user: inst
      end
    end
  end
end
