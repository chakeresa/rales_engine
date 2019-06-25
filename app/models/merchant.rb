class Merchant < ApplicationRecord
  has_many :invoices
end
