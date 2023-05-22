class HomeController < ApplicationController
  def index
    @latest_surveys = Survey.last(5).reverse
  end

end
