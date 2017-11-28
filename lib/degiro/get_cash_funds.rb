require 'json'

module DeGiro
  class GetCashFunds
    def initialize(connection)
      @connection = connection
    end

    def get_cash_funds
      params = URI.encode_www_form(cashFunds: 0)
      parse_cash_funds(JSON.parse(@connection.get(url(params)).body))
    end

    private

    def parse_cash_funds(response)
      funds = response['cashFunds']['value'].map do |cash|
        {
          currency: cash['value'].find { |field| field['name'] == 'currencyCode' }['value'],
          amount:   cash['value'].find { |field| field['name'] == 'value' }['value']
        }
      end
      Hash[funds.map { |cash| [cash[:currency], cash[:amount]] }]
    end

    def url(params)
      "#{@connection.urls_map['trading_url']}/v5/update/" \
      "#{@connection.user_data['int_account']};jsessionid=#{@connection.session_id}" \
      "?#{params}"
    end
  end
end
