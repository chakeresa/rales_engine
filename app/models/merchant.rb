class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices
  has_many :items, dependent: :destroy

  validates_presence_of :name

  def self.top_x_by_revenue(limit)
    self.select(:id, :name)
        .select("SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
        .joins(invoices: [:invoice_items, :transactions])
        .merge(Transaction.successful)
        .group(:id)
        .order("revenue DESC")
        .limit(limit)
  end

  def self.top_x_by_items_sold_ct(limit)
    self.select(:id, :name)
        .select("SUM(invoice_items.quantity) AS item_ct")
        .joins(invoices: [:invoice_items, :transactions])
        .merge(Transaction.successful)
        .group(:id)
        .order("item_ct DESC")
        .limit(limit)
  end

  def revenue_by_date(date = nil)
    invoices.revenue_by_date(date)
  end

  def favorite_customer
    customers.select(:id, :first_name, :last_name)
             .select("COUNT(invoices.id) AS invoice_ct")
             .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
             .merge(Transaction.successful)
             .group(:id)
             .order("invoice_ct DESC")
             .first
  end

  def customers_with_pending_invoices
    sql_query = "SELECT DISTINCT c.id, c.first_name, c.last_name
    FROM customers c
      INNER JOIN (
        SELECT i2.id, i2.customer_id, i2.merchant_id
        FROM invoices i2
          EXCEPT
            SELECT i1.id, i1.customer_id, i1.merchant_id
            FROM invoices i1
              INNER JOIN transactions t ON i1.id = t.invoice_id
            WHERE t.result = 'success'
      ) i3 ON c.id = i3.customer_id
    WHERE i3.merchant_id = #{id};"
      
    Customer.find_by_sql(sql_query)
  end
end
