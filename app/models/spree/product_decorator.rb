Spree::Product.class_eval do
  def self.set_product item
    new({ name: item['Description']['value'],
          description: 'This is test description text',
          available_on: Time.now,
          shipping_category_id: 1
    })
  end
end
