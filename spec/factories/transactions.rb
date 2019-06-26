FactoryBot.define do
  factory :transaction do
    association :invoice, factory: :invoice
    sequence(:credit_card_number) { |n| (4000000000000 + n).to_s }
    sequence(:credit_card_expiration_date) { |n| "08/#{ 2000 + n }" }
    result { "success" }
  end
end
