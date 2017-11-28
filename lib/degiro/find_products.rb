require 'json'

module DeGiro
  class FindProducts
    def initialize(connection)
      @connection = connection
    end

    def find_products(search_text:, limit: 7)
      params = URI.encode_www_form(searchText: search_text, limit: limit)
      parse_products(JSON.parse(@connection.get(url(params)).body))
    end

    private

    def parse_products(response)
      response['products'].map do |product|
        {
          id:          product['id'].to_s,
          ticker:      product['symbol'],
          exchange_id: product['exchangeId'],
          isin:        product['isin']
        }
      end
    end

    def url(params)
      "#{@connection.urls_map['product_search_url']}/v5/products/lookup" \
      "?intAccount=#{@connection.user_data['int_account']}" \
      "&sessionId=#{@connection.session_id}" \
      "&#{params}"
    end
  end
end
