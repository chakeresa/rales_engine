class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  attributes :unit_price do |item|
    '%.2f' % (item.unit_price / 100.00)
  end
end
