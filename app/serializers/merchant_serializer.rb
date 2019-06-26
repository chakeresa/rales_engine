class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end
