class InvoiceItemSerializer < BaseSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :item_id, :invoice_id, :quantity

  attributes :unit_price do |item|
    format_price(item.unit_price)
  end
end
