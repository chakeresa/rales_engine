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
end
