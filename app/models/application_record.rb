class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def self.date_criteria(date)
    if date
      beginning_of_day = Time.zone.parse(date)
      end_of_day = beginning_of_day + 1.days
      {created_at: beginning_of_day..end_of_day}
    end
  end
end
