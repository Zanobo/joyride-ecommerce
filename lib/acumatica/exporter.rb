module Acumatica
  module Exporter
    def export_orders body_params
      req = put("#{api_endpoint}/SalesOrder",
                headers: @headers,
                body: body_params.to_json)

      JSON.parse(req.body.force_encoding('UTF-8'))
    end
  end
end
