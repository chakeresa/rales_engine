FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item Name #{n}" }
    sequence(:description) { |n| "Item Description #{n}" }
    sequence(:unit_price) { |n| 500 + n }
    association :merchant, factory: :merchant
  end
end
