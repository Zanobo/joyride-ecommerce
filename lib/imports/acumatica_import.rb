class AcumaticaImport
  include HTTParty

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

    url = 'https://jrcoffee.acumatica.com/sandbox/entity/Default/6.00.001/StockItem?$expand=VendorDetails&$custom=VendorDetails,ItemSettings.BasePrice'

    response = self.get(url, headers: { 'Cookie' => auth_cookie.to_s })
    items = response.parsed_response
    inventory_cd_list = Array.new
    allowed_taxon_list = ['Supplier']
    allowed_taxonomy_list = ['Supplier']
    items.each do |item|

      if item["custom"]["ItemSettings"]["BasePrice"]["value"].to_f > 0.0
        inventory_cd_list.push(item["Description"]["value"])
        search = Spree::Product.find_by_name(item["Description"]["value"])

        if search
          product = search
        else
          product = Spree::Product.new
        end

        product.name = item["Description"]["value"]
        product.description = "This is test description text. Mmmm, this coffee is like a fine wine."
        product.available_on = "2016-10-23 00:00:00"
        product.master.cost_price = item["custom"]["ItemSettings"]["BasePrice"]["value"].to_f
        product.master.cost_currency = 'USD'
        product.master.price = item["custom"]["ItemSettings"]["BasePrice"]["value"].to_f
        product.shipping_category_id = 1

        if not item["VendorDetails"].empty?
          allowed_taxon_list.push(item["VendorDetails"][0]["VendorName"]["value"])

          supplier_taxonomy = Spree::Taxonomy.find_by_name("Supplier")
          if not supplier_taxonomy
            supplier_taxonomy = Spree::Taxonomy.new
            supplier_taxonomy.name = "Supplier"
            supplier_taxonomy.save!
          else
            supplier_taxonomy.name = "Supplier"
            supplier_taxonomy.save!
          end

          supplier_parent = Spree::Taxon.find_by_name("Supplier")
          if not supplier_parent
            supplier_parent = Spree::Taxon.new
            supplier_parent.name = "Supplier"
            supplier_parent.permalink = "supplier"
            supplier_parent.taxonomy = supplier_taxonomy
            supplier_parent.save!
          else
            supplier_parent.name = "Supplier"
            supplier_parent.permalink = "supplier"
            supplier_parent.taxonomy = supplier_taxonomy
            supplier_parent.save!
          end

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

        product.save!
      end
    end

    Spree::Product.find_each do |product|
      product.delete if not inventory_cd_list.include?(product.name)
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

end