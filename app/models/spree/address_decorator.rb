Spree::Address.class_eval do
  def self.set_address address
    return nil unless address['Address']

    Spree::Address.new({
      firstname: address['FirstName']['value'],
      lastname: address['LastName']['value'],
      address1: address['Address']['AddressLine1']['value'],
      address2: address['Address']['AddressLine2']['value'],
      city: address['Address']['City']['value'],
      zipcode: address['Address']['PostalCode']['value'],
      state_name: address['Address']['State']['value'],
      phone: address['Phone1']['value']
    })
  end
end
