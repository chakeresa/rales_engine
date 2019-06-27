class RevenueSerializer
  def initialize(total_revenue)
    @total_revenue = '%.2f' % (total_revenue / 100.00)
  end

  def render
    {"data":
      {
        attributes: {
          "total_revenue": @total_revenue
        }
      }
    }.to_json
  end
end
