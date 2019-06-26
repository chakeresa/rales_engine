class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  validates_presence_of :name

  def self.search(search_hash)
    where(search_hash).first
  end
end
