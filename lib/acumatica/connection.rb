module Acumatica
  module Connection
    def login
      body = {
        name: ENV['ACUMATICA_USERNAME'],
        password: ENV['ACUMATICA_PASSWORD'],
        company: ENV['ACUMATICA_COMPANY']
      }.to_json

      res = post("#{base_uri}/auth/login", headers: @headers, body: body)
      default_cookies.add_cookies(parse_cookies(res.headers['set-cookie']))
      res
    end

    def logout
      self.class.post("#{base_uri}/auth/logout")
    end

    private

    def parse_cookies cookies
      cookies.scan(/[a-z0-9_.]*=\w[^\/;]*/i).uniq.map do |cookie|
        values = cookie.split('=')
        next if values.count != 2
        values
      end.compact.to_h
    end
  end
end
