class MerchantSerializer < BaseSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end
