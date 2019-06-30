class BaseSerializer
  def self.render(attr_hash)
    {"data":
      {
        attributes: formatted_attributes(attr_hash)
      }
    }
  end

  private

  def self.format_price(price)
    '%.2f' % (price / 100.00)
  end

  def self.formatted_attributes(attr_hash)
    attr_hash.map do |key_value_ary|
      [key_value_ary[0], format_attr(key_value_ary[1])]
    end.to_h
  end
end
