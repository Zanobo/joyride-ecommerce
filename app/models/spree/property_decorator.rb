Spree::Property.class_eval do
  def self.find_or_create_by
    allowed_properties = ['Supplier', 'Item Status', 'Price Class']

    allowed_properties.each do |property|
      find_by(name: property) || create(name: property, presentation: property)
    end
  end
end
