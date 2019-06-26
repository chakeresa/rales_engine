FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant Name #{n}" }
    sequence(:created_at) { |n| Time.now - (3600 * 24 * n) }
    sequence(:updated_at) { |n| Time.now - (3600 * 24 * n - 3600) }
  end
end
