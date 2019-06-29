class ApplicationController < ActionController::API
  def dollars_to_cents(dollars)
    (dollars.to_f * 100).round(0).to_i
  end
end
