module Acumatica
  module QueryFilter
    def get_restriction_groups
      restriction_url = "#{api_endpoint}/ActiveRestrictionGroups?$filter=Active eq true"
      get(restriction_url, timeout: 360).map { |group| group['GroupName']['value'] }
    end

    def get_items_by_restriction_groups(group)
      item_skus = get_by_restriction_group(group, 'item')
        .map { |c| c['InventoryCD']['value'] }
      Spree::Variant.where(sku: item_skus)
    end

    def get_customer_by_restriction_groups(group)
      company_names = get_by_restriction_group(group, 'customer')
        .map { |c| c['CustomerID']['value'] }
      Spree::User.where(company_name: company_names)
    end

    def get_customer_orders(customer)
      filter = "CustomerID eq '#{customer}'"
      order_url = "#{api_endpoint}/SalesOrder?$expand=SalesOrderLines&$filter=#{filter}"
      orders = JSON.parse(get(order_url, timeout: 360).body.force_encoding('UTF-8'))
      orders.map do |order|
        {
          'Date' => order['Date']['value'],
          'OrderNbr' => order['OrderNbr']['value'],
          'OrderType' => order['OrderType']['value'],
          'PaymentMethod' => order['PaymentMethod']['value'],
          'ShipVia' => order['ShipVia']['value'],
          'Status' => order['Status']['value'],
          'SalesOrderLines' => order['SalesOrderLines'].map do |order_line|
            {
              'Description' => order_line['Description']['value'],
              'Branch' => order_line['Branch']['value'],
              'ExtPrice' => order_line['ExtPrice']['value'],
              'InventoryID' => order_line['InventoryID']['value'],
              'Quantity' => order_line['Quantity']['value'],
              'UOM' => order_line['UOM']['value']
            }
          end
        }
      end
    end

    private

    def get_by_restriction_group(group, type)
      filter = "GroupName eq '#{group}' and Active eq true and Included eq true"
      url = "#{api_endpoint}/#{type.capitalize}RestrictionGroups?$filter=#{filter}"
      JSON.parse(get(url, timeout: 360).body.force_encoding('UTF-8'))
    end
  end
end
