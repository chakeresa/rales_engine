class ItemSerializer < BaseSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  attributes :unit_price do |item|
    format_price(item.unit_price)
  end
end
