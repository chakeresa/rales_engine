class PriceSerializer
  def initialize(attr_hash)
    @attr_hash = attr_hash
  end

  def render
    {"data":
      {
        attributes: formatted_attributes
      }
    }.to_json
  end

  private

  def formatted_attributes
    @attr_hash.map do |key_value_ary|
      [key_value_ary[0], '%.2f' % (key_value_ary[1] / 100.00)]
    end.to_h
  end
end
