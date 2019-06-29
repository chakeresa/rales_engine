FactoryBot.define do
  factory :customer do
    sequence(:first_name) { |n| "Customer First Name #{n}" }
    sequence(:last_name) { |n| "Customer Last Name #{n}" }
  end
end
