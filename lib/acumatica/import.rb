module Acumatica
  include HTTParty
  module_function

  URL = "https://#{ENV['ACUMATICA_ERP_URL']}.acumatica.com/entity"
  API = URL + '/Ecommerce/6.00.001'

  def login
    res = post("#{Acumatica::URL}/auth/login",
               { headers:
                 { 'Content-Type' => 'application/json' },
                 body: {
                   name: ENV['ACUMATICA_USERNAME'],
                   password: ENV['ACUMATICA_PASSWORD'],
                   company: ENV['ACUMATICA_COMPANY']
                 }.to_json
               })

    default_cookies.add_cookies(parse_cookies(res.headers['set-cookie']))
    res
  end

  def logout
    post("#{Acumatica::URL}/auth/logout")
  end

  def import_customers top=500
    expand = '$expand=MainContact,BillingContact,ShippingContact'
    customer_url = "#{Acumatica::API}/Customer?#{expand}&$top=#{top}"

    customers = get(customer_url, timeout: 360).parsed_response
    customers.each do |customer|
      user = Spree::User.find_or_create_by(customer)
      billing = Spree::Address.set_address(customer['BillingContact'])
      shipping = Spree::Address.set_address(customer['ShippingContact'])
      user.bill_address ||= billing
      user.ship_address ||= shipping
      user.save!
    end
  rescue Encoding::CompatibilityError => e
    false
  end

  def import_items top=nil
    expand = '$expand=VendorDetails'
    custom = '$custom=VendorDetails,ItemSettings.BasePrice,ItemSettings.PriceClassID'

    item_url = "#{Acumatica::API}/StockItem?#{expand}&#{custom}&$top=#{top}"
    items = get(item_url, timeout: 360).parsed_response

    taxonomy = Spree::Taxonomy.find_or_create_by('Supplier')
    taxon = Spree::Taxon.find_or_create_by('Supplier', taxonomy)
    Spree::Property.find_or_create_by

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
  rescue Encoding::CompatibilityError => e
    false
  end

  def parse_cookies cookies
    parsed = cookies.scan(/[a-z0-9_.]*=\w[^\/;]*/i).uniq
    parsed.map do |cookie|
      values = cookie.split('=')
      next if values.count != 2
      values
    end.compact.to_h
  end
end
