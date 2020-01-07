# DeGiro

A simple Ruby client for [DeGiro](https://www.degiro.co.uk/). Inspired by this [javascript client](https://github.com/pladaria/degiro).

DeGiro's API is likely to change in the future and I make no guarantees that I'll be making changes to keep the client up-to-date. Use this software at your own risk!

## How to use

Install the gem with `gem install degiro`. Supported commands are shown below.

```
require 'degiro'

client = DeGiro::Client.new(login: 'my_login', password: 'my_password')

client.get_orders
client.get_portfolio
client.get_cash_funds
client.get_transactions

id = client.find_products(search_text: 'GOOG').first[:id]
client.find_product_by_id(id: id)

client.create_market_buy_order(product_id: id, size: 10)
client.create_market_sell_order(product_id: id, size: 10)
client.create_limit_buy_order(product_id: id, size: 10, price: 1000)
client.create_limit_sell_order(product_id: id, size: 10, price: 1000)
```
