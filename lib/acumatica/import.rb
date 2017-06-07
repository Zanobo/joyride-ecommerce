module Acumatica
  include HTTParty
  base_uri "https://#{ENV['ACUMATICA_ERP_URL']}.acumatica.com/entity"
  headers 'Content-Type' => 'application/json;charset=utf-8'
  module_function
  API = base_uri + '/Ecommerce/6.00.001'

  def login
    res = post("#{base_uri}/auth/login",
               { body: {
                   name: ENV['ACUMATICA_USERNAME'],
                   password: ENV['ACUMATICA_PASSWORD'],
                   company: ENV['ACUMATICA_COMPANY']
                 }.to_json
               })

    default_cookies.add_cookies(parse_cookies(res.headers['set-cookie']))
    res
  end

  def logout
    post("#{base_uri}/auth/logout")
  end

  def import_customers top=500
    expand = '$expand=MainContact,BillingContact,ShippingContact'
    customer_url = "#{Acumatica::API}/Customer?#{expand}&$top=#{top}"

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

    item_url = "#{Acumatica::API}/StockItem?#{expand}&#{custom}&$top=#{top}"
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

  def restriction_groups
    restriction_url = "#{Acumatica::API}/ActiveRestrictionGroups?$filter=Active eq true"
    get(restriction_url, timeout: 360).map { |group| group['GroupName']['value'] }
  end

  def get_items_by_restriction_groups group
    filter = "GroupName eq '#{group}' and Active eq true and Included eq true"
    items_url = "#{Acumatica::API}/ItemRestrictionGroups?$filter=#{filter}"
    item_ids = JSON.parse(get(items_url, timeout: 360).body.force_encoding('UTF-8'))
      .map { |c| c['InventoryCD']['value'] }
    Spree::Variant.where(id: item_ids)
  end

  def get_customer_by_restriction_groups group
    filter = "GroupName eq '#{group}' and Active eq true and Included eq true"
    customer_url = "#{Acumatica::API}/CustomerRestrictionGroups?$filter=#{filter}"
    customer_ids = JSON.parse(get(customer_url, timeout: 360).body.force_encoding('UTF-8'))
      .map { |c| c['CustomerID']['value'] }
    Spree::User.where(id: customer_ids)
  end

  def restriction_groups
    restriction_url = "#{Acumatica::API}/ActiveRestrictionGroup"
    get(restriction_url, timeout: 360).map { |group| group['GroupName']['value'] }
  end

  def get_items_by_restriction_groups group
    custom_url = "#{Acumatica::API}/CustomStockItem?$filter=GroupName eq '#{group}'"
    byebug
    item_ids = get(custom_url, timeout: 360).map { |group| group['InventoryID']['value'] }
    Spree::Variant.where(id: item_ids)
  end

  def parse_cookies cookies
    cookies.scan(/[a-z0-9_.]*=\w[^\/;]*/i).uniq.map do |cookie|
      values = cookie.split('=')
      next if values.count != 2
      values
    end.compact.to_h
  end
end
