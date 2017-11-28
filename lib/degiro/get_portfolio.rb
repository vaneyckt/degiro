require 'json'

module DeGiro
  class GetPortfolio
    def initialize(connection)
      @connection = connection
    end

    def get_portfolio
      params = URI.encode_www_form(portfolio: 0)
      parse_portfolio(JSON.parse(@connection.get(url(params)).body))
    end

    private

    def parse_portfolio(response)
      portfolio = response['portfolio']['value'].map do |order|
        {
          size:       order['value'].find { |field| field['name'] == 'size' }['value'],
          value:      order['value'].find { |field| field['name'] == 'price' }['value'],
          product_id: order['value'].find { |field| field['name'] == 'id' }['value'].to_s,
          product:    order['value'].find { |field| field['name'] == 'product' }['value']
        }
      end
      portfolio.select { |entry| entry[:size] > 0 }
    end

    def url(params)
      "#{@connection.urls_map['trading_url']}/v5/update/" \
      "#{@connection.user_data['int_account']};jsessionid=#{@connection.session_id}" \
      "?#{params}"
    end
  end
end
