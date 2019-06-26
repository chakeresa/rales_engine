class Transaction < ApplicationRecord
  scope :successful, -> { where(result: "success") }
  belongs_to :invoice
end
