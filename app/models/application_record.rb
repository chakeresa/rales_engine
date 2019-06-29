class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(search_hash)
    search_all(search_hash).first
  end

  def self.search_all(search_hash)
    where(search_hash).order(:id)
  end

  def self.random
    find(self.pluck(:id).sample)
  end

  private

  # TO DO: delete if possible (refactor of Invoice::revenue_by_date)
  def self.date_criteria(date)
    if date
      beginning_of_day = Time.zone.parse(date)
      end_of_day = beginning_of_day + 1.days
      {created_at: beginning_of_day..end_of_day}
    end
  end
end
