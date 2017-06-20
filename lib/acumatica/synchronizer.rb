require 'acumatica/connection'
require 'acumatica/importer'
require 'acumatica/exporter'
require 'acumatica/query_filter'

module Acumatica
  class Synchronizer
    include HTTParty
    include Acumatica::Connection
    include Acumatica::Importer
    include Acumatica::QueryFilter
    include Acumatica::Exporter

    delegate :post, :get, :put, :default_cookies, to: :class

    attr_reader :base_uri, :headers, :api_endpoint

    def initialize(autologin: true)
      @exitbase_uri     = "https://jrcoffee.acumatica.com/entity"
      @headers      = { 'Content-Type' => 'application/json;charset=utf-8' }
      @api_endpoint = @base_uri + '/Ecommerce/6.00.001'

      login if autologin
    end
  end
end
