class PriceSerializer < BaseSerializer
  private

  def self.format_attr(attr)
    format_price(attr)
  end
end
