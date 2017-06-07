module Acumatica
  module Importer
    def import_customers top=500
      expand = '$expand=MainContact,BillingContact,ShippingContact'
      customer_url = "#{api_endpoint}/Customer?#{expand}&$top=#{top}"
      customers = JSON.parse get(customer_url, timeout: 360).body.force_encoding('UTF-8')
      customers.each do |customer|
        user = Spree::User.find_or_create_by(customer)
        billing = Spree::Address.set_address(customer['BillingContact'])
        shipping = Spree::Address.set_address(customer['ShippingContact'])
        user.bill_address ||= billing
        user.ship_address ||= shipping
        user.save!
      end
    end

    def import_items top=nil
      taxonomy = Spree::Taxonomy.find_or_create_by('Supplier')
      taxon = Spree::Taxon.find_or_create_by('Supplier', taxonomy)
      Spree::Property.find_or_create_by

      expand = '$expand=VendorDetails'
      custom = '$custom=VendorDetails,ItemSettings.BasePrice,ItemSettings.PriceClassID'
      item_url = "#{api_endpoint}/StockItem?#{expand}&#{custom}&$top=#{top}"
      items = JSON.parse get(item_url, timeout: 360).body.force_encoding('UTF-8')

      items.each do |item|
        variant = Spree::Variant.find_or_create_by(item)
        product = variant.product || Spree::Product.set_product(item)

        if item['VendorDetails']
          vendor_taxon = Spree::Taxon.update_taxon(item, taxon, taxonomy)
          product.taxons << vendor_taxon unless product.taxons.exists?(vendor_taxon.id)
          product.update(master: variant)
          variant.update(product: product)

          # TODO: the link is not working and we can set the image locally in a folder
          # if product.master.images.empty?
          #   product.master.images.create!(attachment: 'http://www.specopscomm.com/images/portfolio_thumbs/joyride-coffee.jpg')
          # end
        end
      end
    end
  end
end
