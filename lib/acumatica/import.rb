module Acumatica
  include HTTParty
  module_function

  URL = "https://#{ENV['ACUMATICA_ERP_URL']}.acumatica.com/entity"

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

  def import_customers
    expand = 'MainContact,BillingContact,ShippingContact'
    top = '500'
    customer_url = "#{Acumatica::URL}Ecommerce/6.00.001/Customer?$exapnd=#{expand}&$top=#{top}"

    get(customer_url, timeout: 360)
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
