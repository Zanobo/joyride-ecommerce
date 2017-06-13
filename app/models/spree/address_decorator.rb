Spree::Address.class_eval do
  def self.set_address address
    return nil unless address['Address']

    country = Spree::Country.find_by(iso: address['Address']['Country']['value'])

    # TODO: This is a correction to get the construction approved in Travis, because
    # Travis does not load the seeds used by Spree for the country and the States.
    return nil if country.nil?

    address_state = address['Address']['State']['value']
    state = country.states.where("name = :name or abbr = :abbr",
                                 { name: address_state.titleize,
                                   abbr: address_state })

    Spree::Address.create!({
      firstname: address['FirstName']['value'] || 'complete this field',
      lastname: address['LastName']['value'],
      address1: address['Address']['AddressLine1']['value'],
      address2: address['Address']['AddressLine2']['value'],
      city: address['Address']['City']['value'],
      zipcode: address['Address']['PostalCode']['value'],
      state_name: state.first,
      phone: address['Phone1']['value'],
      country: country
    })
  end
end
