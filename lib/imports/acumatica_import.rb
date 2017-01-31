class AcumaticaImport
  include HTTParty

  def self.acumatica_login
    auth = {:name => "zach", :password => "joyridecode", :company => "Joyride Coffee"}
    auth_url = 'https://jrcoffee.acumatica.com/sandbox/entity/auth/Login'
    get_response = self.get(auth_url)
    get_response_cookie = self.parse_set_cookie(get_response.headers['Set-Cookie'])
    login = self.post(auth_url,
                      :body => auth.to_json,
                      :headers => {
                          'Content-Type' => 'application/json',
                          'Cookie' => get_response_cookie.to_s} )

    auth_cookie = self.parse_set_cookie(login.headers["set-cookie"])
    self.default_cookies.add_cookies(auth_cookie)

    auth_cookie
  end

  def self.import_customers

    auth_cookie = self.acumatica_login

    expand = 'MainContact,BillingContact,ShippingContact'
    top = '500'

    url = 'https://jrcoffee.acumatica.com/sandbox/entity/Default/6.00.001/Customer?$expand='+ expand +'&$top=' + top

    response = self.get(url, headers: { 'Cookie' => auth_cookie.to_s }, timeout: 360)
    items = response.parsed_response

    items.each do |item|
      if item["MainContact"]["Email"]["value"] and not item["MainContact"]["Email"]["value"].include? ","
        user = Spree::User.find_by_email(item["MainContact"]["Email"]["value"].downcase)
        if not user
          user = Spree::User.new
        end
        user.email = item["MainContact"]["Email"]["value"]
        user.login = item["MainContact"]["Email"]["value"]
        user.first_name = item["MainContact"]["FirstName"]["value"]
        user.last_name = item["MainContact"]["LastName"]["value"]
        user.company_name = item["CustomerID"]["value"]
        user.price_class = item["PriceClassID"]["value"]

        if item["BillingContact"]["Address"]
          if user.bill_address
            bill_address = user.bill_address
          else
            bill_address = Spree::Address.new
          end
          bill_address.firstname = item["BillingContact"]["FirstName"]["value"] ? item["BillingContact"]["FirstName"] : nil
          bill_address.lastname = item["BillingContact"]["LastName"]["value"] ? item["BillingContact"]["LastName"] : nil
          bill_address.address1 = item["BillingContact"]["Address"]["AddressLine1"]["value"]
          bill_address.address2 = item["BillingContact"]["Address"]["AddressLine2"]["value"]
          bill_address.city = item["BillingContact"]["Address"]["City"]["value"]
          bill_address.zipcode = item["BillingContact"]["Address"]["PostalCode"]["value"]
          bill_address.phone = item["BillingContact"]["Phone1"]["value"]
          bill_address.state_name = item["BillingContact"]["Address"]["State"]["value"]
          bill_address.country_id = 232
          user.bill_address = bill_address
        end

        if item["ShippingContact"]["Address"]
          if user.ship_address
            ship_address = user.ship_address
          else
            ship_address = Spree::Address.new
          end
          ship_address.firstname = item["ShippingContact"]["FirstName"]["value"]
          ship_address.lastname = item["ShippingContact"]["LastName"]["value"]
          ship_address.address1 = item["ShippingContact"]["Address"]["AddressLine1"]["value"]
          ship_address.address2 = item["ShippingContact"]["Address"]["AddressLine2"]["value"]
          ship_address.city = item["ShippingContact"]["Address"]["City"]["value"]
          ship_address.zipcode = item["ShippingContact"]["Address"]["PostalCode"]["value"]
          ship_address.phone = item["ShippingContact"]["Phone1"]["value"]
          ship_address.state_name = item["ShippingContact"]["Address"]["State"]["value"]
          ship_address.country_id = 232
          user.ship_address = ship_address
        end

        user.password = 'testpass'

        begin
          user.save!
          sleep(5)
        rescue
          byebug
        end
      end
    end

  end

  def self.import_full_data

    auth = {:name => "zach", :password => "joyridecode", :company => "Joyride Coffee"}
    auth_url = 'https://jrcoffee.acumatica.com/sandbox/entity/auth/Login'
    get_response = self.get(auth_url)
    get_response_cookie = self.parse_set_cookie(get_response.headers['Set-Cookie'])
    login = self.post(auth_url,
                      :body => auth.to_json,
                      :headers => {
                          'Content-Type' => 'application/json',
                          'Cookie' => get_response_cookie.to_s} )

    auth_cookie = self.parse_set_cookie(login.headers["set-cookie"])
    self.default_cookies.add_cookies(auth_cookie)

    expand = '$expand=VendorDetails'
    custom = '$custom=VendorDetails,ItemSettings.BasePrice,ItemSettings.PriceClassID'

    url = 'https://jrcoffee.acumatica.com/sandbox/entity/Default/6.00.001/StockItem?' + expand + '&' + custom

    response = self.get(url, headers: { 'Cookie' => auth_cookie.to_s }, timeout: 360)
    items = response.parsed_response

    allowed_taxon_list = ['Supplier']
    allowed_taxonomy_list = ['Supplier']

    supplier_taxonomy = Spree::Taxonomy.find_by_name('Supplier')
    if not supplier_taxonomy
      supplier_taxonomy = Spree::Taxonomy.new
      supplier_taxonomy.name = 'Supplier'
      supplier_taxonomy.save!
    end

    supplier_parent = Spree::Taxon.find_by_name('Supplier')
    if not supplier_parent
      supplier_parent = Spree::Taxon.new
      supplier_parent.name = 'Supplier'
      supplier_parent.permalink = 'supplier'
      supplier_parent.taxonomy = supplier_taxonomy
      supplier_parent.save!
    else
      supplier_parent.permalink = 'supplier'
      supplier_parent.taxonomy = supplier_taxonomy
      supplier_parent.save!
    end

    allowed_properties_list = ['Supplier', 'Item Status', 'Price Class']

    allowed_properties_list.each do |property|
      main_property = Spree::Property.find_by_name(property)
      if not main_property
        main_property = Spree::Property.new
        main_property.name = property
        main_property.presentation = property
        main_property.save!
      end
    end

    product_name_list = Array.new
    product_cd_list = Array.new
    items.each do |item|

      if item["custom"]["ItemSettings"]["BasePrice"]["value"].to_f > 0.0
        product_name_list.push(item["Description"]["value"])
        product_cd_list.push(item["InventoryID"]["value"])
        variant_search = Spree::Variant.find_by_sku(item["InventoryID"]["value"])

        if variant_search
          variant = variant_search
        else
          variant = Spree::Variant.new
        end

        variant.sku = item["InventoryID"]["value"]
        variant.is_master = true
        variant.price = item["custom"]["ItemSettings"]["BasePrice"]["value"].to_f
        variant.cost_price = item["custom"]["ItemSettings"]["BasePrice"]["value"].to_f
        variant.cost_currency = 'USD'

        if variant.product
          product = variant.product
        else
          product = Spree::Product.new
        end

        product.name = item["Description"]["value"]
        product.description = "This is test description text. Mmmm, this coffee is like a fine wine."
        product.available_on = "2016-10-23 00:00:00"
        product.shipping_category_id = 1

        vendor_name = ''
        if not item["VendorDetails"].empty?
          vendor_name = item["VendorDetails"][0]["VendorName"]["value"]
          allowed_taxon_list.push(item["VendorDetails"][0]["VendorName"]["value"])

          supplier_search = Spree::Taxon.find_by_name(item["VendorDetails"][0]["VendorName"]["value"])

          if supplier_search
            supplier_search.parent_id = supplier_parent.id
            supplier_search.name = item["VendorDetails"][0]["VendorName"]["value"]
            supplier_search.permalink = "supplier/" + item["VendorDetails"][0]["VendorID"]["value"].to_s
            supplier_search.taxonomy = supplier_taxonomy
            supplier_search.save!
          end

          if not product.taxons.exists?(supplier_search)
            if supplier_search
              product.taxons << supplier_search
            else
              supplier_taxon = product.taxons.new
              supplier_taxon.parent_id = supplier_parent.id
              supplier_taxon.name = item["VendorDetails"][0]["VendorName"]["value"]
              supplier_taxon.permalink = "supplier/" + item["VendorDetails"][0]["VendorID"]["value"].to_s
              supplier_taxon.taxonomy_id = 1
            end
          end
        end

        property_hash = Hash["Supplier"    => vendor_name,
                             "Item Status" => item["ItemStatus"]["value"],
                             "Price Class" => item["custom"]["ItemSettings"]["PriceClassID"]["value"]]
        property_hash.each do |property_name, property_value|
          property_object = Spree::ProductProperty.find_by_value(property_value)

          if not product.product_properties.exists?(property_object)
            prod_property = product.product_properties.new
            prod_property.property = Spree::Property.find_by_name(property_name)
            prod_property.value = property_value
          end
        end

        product.master = variant
        product.save!
        variant.product = product
        variant.save!

        if product.master.images.empty?
          product.master.images.create!(attachment: 'http://www.specopscomm.com/images/portfolio_thumbs/joyride-coffee.jpg')
        end

      end
    end

    Spree::Product.find_each do |product|
      product.delete if not product_name_list.include?(product.name)
    end

    Spree::Variant.find_each do |variant|
      variant.delete if not product_cd_list.include?(variant.sku)
    end

    total_taxon_list = Array.new
    Spree::Taxon.find_each do |taxon|
      if not total_taxon_list.include?(taxon.name)
        total_taxon_list.push(taxon.name)
        taxon.delete if not allowed_taxon_list.include?(taxon.name)
      else
        taxon.delete
      end
    end

    total_taxonomy_list = Array.new
    Spree::Taxonomy.find_each do |taxononomy|
      if not total_taxonomy_list.include?(taxononomy.name)
        total_taxonomy_list.push(taxononomy.name)
        taxononomy.delete if not allowed_taxonomy_list.include?(taxononomy.name)
      else
        taxononomy.delete
      end
    end

  end

  def self.parse_set_cookie(all_cookies_string)
    cookies = Hash.new

    if all_cookies_string.present?
      # single cookies are devided with comma
      all_cookies_string.split(',').each {
        # @type [String] cookie_string
          |single_cookie_string|
        # parts of single cookie are seperated by semicolon; first part is key and value of this cookie
        # @type [String]
        cookie_part_string  = single_cookie_string.strip.split(';')[0]
        # remove whitespaces at beginning and end in place and split at '='
        # @type [Array]
        cookie_part         = cookie_part_string.strip.split('=')
        # @type [String]
        key                 = cookie_part[0]
        # @type [String]
        value               = cookie_part[1]

        # add cookie to Hash
        cookies[key] = value
      }
    end

    cookies
  end

  def self.clear_product_data
    Spree::Product.find_each do |product|
      product.delete
    end

    Spree::Variant.find_each do |variant|
      variant.delete
    end
  end

end