module Acumatica
  include HTTParty
  module_function

  URL = "https://#{ENV['ACUMATICA_ERP_URL']}.acumatica.com/entity/auth/"

  def login
    res = post("#{Acumatica::URL}login",
               { headers:
                 { 'Content-Type' => 'application/json' },
                 body: {
                   name: ENV['ACUMATICA_USERNAME'],
                   password: ENV['ACUMATICA_PASSWORD'],
                   company: ENV['ACUMATICA_COMPANY']
                 }.to_json
               })
    @cookie = res.headers['set-cookie']
    res
  end

  def logout
    return unless @cookie
    post("#{Acumatica::URL}logout", { headers: { 'Cookie': @cookie } })
  end
end
