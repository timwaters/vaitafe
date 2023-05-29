class HomeController < ApplicationController
  def index
    @latest_surveys = Survey.last(5).reverse
    @active_users = User.order(:updated_at).last(5)
  end

end
