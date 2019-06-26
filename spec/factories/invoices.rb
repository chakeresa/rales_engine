FactoryBot.define do
  factory :invoice do
    association :customer, factory: :customer
    association :merchant, factory: :merchant
    status { "shipped" }
  end
end
