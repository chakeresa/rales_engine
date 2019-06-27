class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices
  has_many :items, dependent: :destroy

  validates_presence_of :name

  def self.search(search_hash)
    search_all(search_hash).first
  end

  def self.search_all(search_hash)
    where(search_hash)
  end

  def self.random
    find(self.pluck(:id).sample)
  end

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
end
