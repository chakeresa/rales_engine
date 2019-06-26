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

  def self.top_x_by_revenue(limit)
    self.joins(invoices: :invoice_items)
        .select(:id, :name)
        .select("SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
        .group(:id)
        .order("revenue DESC")
        .limit(limit)
  end
end
