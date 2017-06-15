module Acumatica
  module Exporter
    def export_orders body_params
      req = put("#{api_endpoint}/SalesOrder",
                headers: @headers,
                body: body_params.to_json)

      JSON.parse(req.body.force_encoding('UTF-8'))
    end

    def export_address customer_id, body_params
      filter = "$filter=CustomerID eq '#{customer_id}'"
      req = put("#{api_endpoint}/Customer?$expand=MainContact&#{filter}",
                headers: @headers,
                body: body_params.to_json)

      JSON.parse(req.body.force_encoding('UTF-8'))
    end
  end
end
