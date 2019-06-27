class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
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

  def self.revenue_by_date(date)
    beginning_of_day = Time.zone.parse(date)
    end_of_day = beginning_of_day + 1.days
    date_range = beginning_of_day..end_of_day

    Invoice.joins(:invoice_items, :transactions).where(created_at: date_range).merge(Transaction.successful).sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
