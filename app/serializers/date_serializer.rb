class DateSerializer < BaseSerializer
  private

  def self.format_attr(attr)
    attr.to_date.to_s
  end
end
