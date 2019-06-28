class PriceSerializer < BaseSerializer
  def self.render(attr_hash)
    {"data":
      {
        attributes: formatted_attributes(attr_hash)
      }
    }.to_json
  end

  private

  def self.formatted_attributes(attr_hash)
    attr_hash.map do |key_value_ary|
      [key_value_ary[0], format_price(key_value_ary[1])]
    end.to_h
  end
end
