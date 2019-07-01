class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices

  def favorite_merchants(limit)
    merchants.select(:id, :name)
             .select("COUNT(transactions.id) AS transaction_ct")
             .joins("INNER JOIN transactions ON invoices.id = transactions.invoice_id")
             .merge(Transaction.successful)
             .group(:id)
             .order("transaction_ct DESC")
             .limit(limit)
  end
end
