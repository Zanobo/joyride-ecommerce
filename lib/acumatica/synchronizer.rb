require 'acumatica/connection'
require 'acumatica/importer'
require 'acumatica/query_filter'

module Acumatica
  class Synchronizer
    include HTTParty
    include Acumatica::Connection
    include Acumatica::Importer
    include Acumatica::QueryFilter

    delegate :post, :get, :default_cookies, to: :class

    attr_reader :base_uri, :headers, :api_endpoint

    def initialize(autologin: true)
      @base_uri     = "https://#{ENV['ACUMATICA_ERP_URL']}.acumatica.com/entity"
      @headers      = { 'Content-Type' => 'application/json;charset=utf-8' }
      @api_endpoint = @base_uri + '/Ecommerce/6.00.001'

      login if autologin
    end
  end
end
