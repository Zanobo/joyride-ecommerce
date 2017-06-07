FactoryGirl.define do
  factory :product, class: Spree::Product do
    sequence(:name) { |n| "product #{n}" }
    description 'this is a description'
    available_on Time.now
    shipping_category_id 1
    price 45.0
  end
end
