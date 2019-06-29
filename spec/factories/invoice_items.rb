FactoryBot.define do
  factory :invoice_item do
    association :item, factory: :item
    association :invoice, factory: :invoice
    sequence(:quantity) { |n| 3 + n }
    sequence(:unit_price) { |n| 42 + n }
  end
end
