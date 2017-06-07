FactoryGirl.define do
  factory :user, class: Spree::User do
    sequence(:email) { |n| "user#{n}@joyride.com" }
    password 'password'
    first_name 'John'
    last_name 'Doe'
    company_name '1100ARCHIT'
    approved true
  end
end
