FactoryGirl.define do
  factory :variant, class: Spree::Variant do
    sku 'ABUAIRP30'
    is_master true
    price 45.0
    cost_price 45.0
    cost_currency 'USD'
    product
  end
end
