Spree::Taxon.class_eval do
  def self.find_or_create_by name, taxonomy
    taxon = find_by(name: name) || new(name: name)
    taxon.update(permalink: name.downcase, taxonomy: taxonomy)
    taxon
  end

  def self.update_taxon item, taxon, taxonomy
    taxon = find_or_create_by(item['VendorDetails'][0]['VendorName']['value'], taxonomy)
    taxon.update(parent_id: taxon,
                 permalink: "supplier/#{item['VendorDetails'][0]['VendorID']['value']}")
    taxon
  end
end
