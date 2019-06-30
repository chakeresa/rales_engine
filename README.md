# Rales Engine - README

## About

Rales Engine is a JSON API which exposes data from six database tables for a basic online store. Only `GET` requests are possible at this time. Only ReSTful controller actions were allowed (just `#index` & `#show`). 

### <a name="schema"></a>Schema

![Rales Engine Schema](/public/rales_engine_schema.png)

### Development

[This Ruby on Rails repo](https://github.com/chakeresa/rales_engine) was built by [Alexandra Chakeres](https://github.com/chakeresa), a Mod 3 student in Turing School of Software & Design's Back End Engineering program. This is the first API I have built, and was completed in one week for the [Rales Engine project](https://backend.turing.io/module3/projects/rails_engine#evaluation).

## Setup on your machine

* Ruby version 2.4.1

* Configuration
`$bundle`

* Database creation
`$bundle exec rake db:drop`
`$bundle exec rake db:create`
`$bundle exec rake db:migrate`

* Database initialization
`$bundle exec rake csv_import`

* How to run the test suite
`$bundle exec rspec`

## Running

Due to the large number of rows in the tables, the API is not deployed online. So just run `$rails s` and then access the development environment on localhost. For example, you could visit http://localhost:3000/api/v1/merchants/random in your browser.

### Endpoints

#### Basic endpoints - for *all 6* tables (`merchants`, `customers`, `transactions`, `invoices`, `items`, `invoice_items`)

 - `GET /api/v1/merchants` shows information for all merchants
 - `GET /api/v1/merchants/42` shows information for a single merchant (based on the `id`)
 - `GET /api/v1/merchants/find_all?name=Dibbert Group` / `Dibbert%20Group` shows information for all merchants whose `name` attribute is `Dibbert Group`. This can be used to search for any of the attributes in the [schema](#schema) above. `created_at` and `updated_at` are in the following format: `2012-03-27 14:53:59 UTC` / `2012-03-27%2014:53:59%20UTC`. `unit_price` is in the format of `9.99` for $9.99.
 - `GET /api/v1/merchants/find?name=Dibbert Group` / `Dibbert%20Group` shows information for a single merchant whose `name` attribute is `Dibbert Group`. If multiple rows match, the one with the lowest `id` will be returned. Similar to `find_all` above, this works for all attributes of all tables, and matches the date/price formats outlined there.
 - `GET /api/v1/merchants/random` shows information for a single random merchant

 #### Relationship endpoints

 Replace `:id` with the `id` of the desired resouce in the paths below.
 
Merchants
 - `GET /api/v1/merchants/:id/items` returns a collection of items associated with that merchant
 - `GET /api/v1/merchants/:id/invoices` returns a collection of invoices associated with that merchant from their known orders
Invoices
 - `GET /api/v1/invoices/:id/transactions` returns a collection of associated transactions
 - `GET /api/v1/invoices/:id/invoice_items` returns a collection of associated invoice items
 - `GET /api/v1/invoices/:id/items` returns a collection of associated items
 - `GET /api/v1/invoices/:id/customer` returns the associated customer
 - `GET /api/v1/invoices/:id/merchant` returns the associated merchant
Invoice Items
 - `GET /api/v1/invoice_items/:id/invoice` returns the associated invoice
 - `GET /api/v1/invoice_items/:id/item` returns the associated item
Items
 - `GET /api/v1/items/:id/invoice_items` returns a collection of associated invoice items
 - `GET /api/v1/items/:id/merchant` returns the associated merchant
Transactions
 - `GET /api/v1/transactions/:id/invoice` returns the associated invoice
Customers
 - `GET /api/v1/customers/:id/invoices` returns a collection of associated invoices
 - `GET /api/v1/customers/:id/transactions` returns a collection of associated transactions

 #### Business Intelligence Endpoints

 In addition to the basic endpoints above, some more complicated logic is included in the endpoints below. Note: invoices without succcessful transactions are not counted in revenue totals or statistics.

All Merchants
  - `GET /api/v1/merchants/most_revenue?quantity=2` returns the top 2 merchants ranked by total revenue
  - `GET /api/v1/merchants/most_items?quantity=5` returns the top 5 merchants ranked by total number of items sold
  - `GET /api/v1/merchants/revenue?date=2012-03-27` returns the total revenue for date `2012-03-27` across all merchants (in the format `9.99` for $9.99)
Single Merchant (replace `:id` with the `id` of the desired merchant)
  - `GET /api/v1/merchants/:id/revenue` returns the total revenue for that merchant across successful transactions (in the format `9.99` for $9.99)
  - `GET /api/v1/merchants/:id/revenue?date=2012-03-27` returns the total revenue for that merchant for a specific invoice date, e.g. `2012-03-27` (in the format `9.99` for $9.99)
  - `GET /api/v1/merchants/:id/favorite_customer` returns the customer who has conducted the highest number of successful transactions with the merchant
  - `GET /api/v1/merchants/:id/customers_with_pending_invoices` returns a collection of customers which have pending (unpaid) invoices. A pending invoice has no transactions with a result of success. This means all transactions are failed, or there are no transactions yet.
Items
  - `GET /api/v1/items/most_revenue?quantity=3` returns the top 3 items ranked by total revenue generated
  - `GET /api/v1/items/most_items?quantity=5` returns the top 5 item instances ranked by total number sold
  - `GET /api/v1/items/:id/best_day` returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, it returns the most recent day. The date format returned is like `2012-03-27`.
Customers
  - `GET /api/v1/customers/:id/favorite_merchant` returns a merchant where the customer has conducted the most successful transactions

### Output

Resources are serialized according to the API 1.0 spec. Some aggregates (such as a date or total revenue) are in a bit simpler format -- see below.

#### <a name="merchant_serialization"></a>Merchant(s)

A single merchant is serialized as something like
```json
{"data":{"id":"80","type":"merchant","attributes":{"id":80,"name":"Jakubowski, Predovic and Hudson"}}}
```

A collection of merchants is serialized as something like
```json
{"data":[{"id":"1","type":"merchant","attributes":{"id":1,"name":"Schroeder-Jerde"}},{"id":"2","type":"merchant","attributes":{"id":2,"name":"Klein, Rempel and Jones"}}]}
```

#### Item(s)

A single item is serialized as something like
```json
{"data":{"id":"2465","type":"item","attributes":{"id":2465,"name":"Item A Laudantium","description":"Minima non quia dolore. Veritatis non sed omnis accusantium aspernatur. Natus ex eligendi earum. Ex earum quibusdam.","merchant_id":100,"unit_price":"774.73"}}}
```

A collection of items is serialized similarly. See the [Merchant(s) section above](#merchant_serialization)

#### Invoice(s)

A single invoice is serialized as something like
```json
{"data":{"id":"4416","type":"invoice","attributes":{"id":4416,"customer_id":899,"merchant_id":22,"status":"shipped"}}}
```

A collection of invoices is serialized similarly. See the [Merchant(s) section above](#merchant_serialization)

#### InvoiceItem(s)

A single invoice_item is serialized as something like
```json
{"data":{"id":"6447","type":"invoice_item","attributes":{"id":6447,"item_id":2302,"invoice_id":1452,"quantity":9,"unit_price":"35.90"}}}
```

A collection of invoice_items is serialized similarly. See the [Merchant(s) section above](#merchant_serialization)

#### Customer(s)

A single customer is serialized as something like
```json
{"data":{"id":"269","type":"customer","attributes":{"id":269,"first_name":"Marco","last_name":"Hettinger"}}}
```

A collection of customers is serialized similarly. See the [Merchant(s) section above](#merchant_serialization)

#### Transaction(s)

A single transaction is serialized as something like
```json
{"data":{"id":"4458","type":"transaction","attributes":{"id":4458,"invoice_id":3859,"credit_card_number":"4718678256099157","result":"failed"}}}
```

A collection of transactions is serialized similarly. See the [Merchant(s) section above](#merchant_serialization)

#### Price

Revenues are serialized with the attribute `revenue` (for one merchant) or `total_revenue` (for all merchants), such as
```json
{"data":{"attributes":{"total_revenue":"57493574.87"}}}
```

#### Date

Dates are serialized with the `best_day` attribute, such as
```json
{"data":{"attributes":{"best_day":"2012-03-07"}}}
```
