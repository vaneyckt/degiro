require 'json'

module DeGiro
  class GetOrders
    def initialize(connection)
      @connection = connection
    end

    def get_orders
      params = URI.encode_www_form(orders: 0, historicalOrders: 0, transactions: 0)
      parse_orders(JSON.parse(@connection.get(url(params)).body))
    end

    private

    def parse_orders(response)
      response['orders']['value'].map do |order|
        {
          id:         order['id'],
          type:       order['value'].find { |field| field['name'] == 'buysell' }['value'],
          size:       order['value'].find { |field| field['name'] == 'size' }['value'],
          price:      order['value'].find { |field| field['name'] == 'price' }['value'],
          product_id: order['value'].find { |field| field['name'] == 'productId' }['value'].to_s,
          product:    order['value'].find { |field| field['name'] == 'product' }['value']
        }
      end
    end

    def url(params)
      "#{@connection.urls_map['trading_url']}/v5/update/" \
      "#{@connection.user_data['int_account']};jsessionid=#{@connection.session_id}" \
      "?#{params}"
    end
  end
end
