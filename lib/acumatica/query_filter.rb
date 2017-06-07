module Acumatica
  module QueryFilter
    def get_restriction_groups
      restriction_url = "#{api_endpoint}/ActiveRestrictionGroups?$filter=Active eq true"
      get(restriction_url, timeout: 360).map { |group| group['GroupName']['value'] }
    end

    def get_items_by_restriction_groups(group)
      filter = "GroupName eq '#{group}' and Active eq true and Included eq true"
      items_url = "#{api_endpoint}/ItemRestrictionGroups?$filter=#{filter}"
      item_skus = JSON.parse(get(items_url, timeout: 360).body.force_encoding('UTF-8'))
        .map { |c| c['InventoryCD']['value'] }
      Spree::Variant.where(sku: item_skus)
    end

    def get_customer_by_restriction_groups(group)
      filter = "GroupName eq '#{group}' and Active eq true and Included eq true"
      customer_url = "#{api_endpoint}/CustomerRestrictionGroups?$filter=#{filter}"
      company_names = JSON.parse(get(customer_url, timeout: 360)
        .body.force_encoding('UTF-8')).map { |c| c['CustomerID']['value'] }
      Spree::User.where(company_name: company_names)
    end
  end
end
