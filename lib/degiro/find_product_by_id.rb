require 'json'

module DeGiro
  class FindProductById
    def initialize(connection)
      @connection = connection
    end

    def find_product_by_id(id:)
      parse_product(JSON.parse(find_by_id(id).body))
    end

    private

    def find_by_id(product_id)
      @connection.post(url) do |req|
        req.headers['Content-Type'] = 'application/json; charset=UTF-8'
        req.body = [product_id].to_json
      end
    end

    def parse_product(response)
      {
        id:          response['data'].values[0]['id'].to_s,
        ticker:      response['data'].values[0]['symbol'].to_s,
        exchange_id: response['data'].values[0]['exchangeId'].to_s,
        isin:        response['data'].values[0]['isin'].to_s
      }
    end

    def url
      "#{@connection.urls_map['product_search_url']}/v5/products/info" \
      "?intAccount=#{@connection.user_data['int_account']}" \
      "&sessionId=#{@connection.session_id}"
    end
  end
end
