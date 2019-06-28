class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.top_x_by_revenue(limit)
    self.select(:id, :name, :description).select(:unit_price, :merchant_id)
        .select("SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
        .joins(invoices: :transactions)
        .merge(Transaction.successful)
        .group(:id)
        .order("revenue DESC")
        .limit(limit)
  end

  def self.top_x_by_items_sold_ct(limit)
    self.select(:id, :name, :description).select(:unit_price, :merchant_id)
        .select("SUM(invoice_items.quantity) AS item_ct")
        .joins(invoices: :transactions)
        .merge(Transaction.successful)
        .group(:id)
        .order("item_ct DESC")
        .limit(limit)
  end
end
