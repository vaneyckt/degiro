require 'date'
require 'json'

module DeGiro
  class GetTransactions
    def initialize(connection)
      @connection = connection
    end

    def get_transactions(from: (Date.today - (365 * 5)).strftime('%d/%m/%Y'), to: Date.today.strftime('%d/%m/%Y'))
      params = URI.encode_www_form(fromDate: from, toDate: to)
      parse_transactions(JSON.parse(@connection.get(url(params)).body))
    end

    private

    def parse_transactions(response)
      response['data']
        .sort_by { |transaction| transaction['date'] }
        .reverse
        .map do |transaction|
          {
            id:         transaction['id'],
            type:       transaction['buysell'],
            size:       transaction['quantity'].abs,
            price:      transaction['price'],
            product_id: transaction['productId'].to_s
          }
        end
    end

    def url(params)
      "#{@connection.urls_map['reporting_url']}/v4/transactions" \
      '?orderId=&product=&groupTransactionsByOrder=false' \
      "&intAccount=#{@connection.user_data['int_account']}" \
      "&sessionId=#{@connection.session_id}" \
      "&#{params}"
    end
  end
end
