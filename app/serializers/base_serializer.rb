class BaseSerializer
  def self.format_price(price)
    '%.2f' % (price / 100.00)
  end
end
