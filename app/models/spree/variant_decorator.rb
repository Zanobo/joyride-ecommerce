Spree::Variant.class_eval do
  def self.find_or_create_by item
    variant = find_by(sku: item['InventoryID']['value'])
    price = item['custom']['ItemSettings']['BasePrice']['value']
    variant || new({ sku: item['InventoryID']['value'],
                     is_master: true,
                     price: price,
                     cost_price: price,
                     cost_currency: 'USD'
                  })
  end
end
