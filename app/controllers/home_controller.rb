class HomeController < ApplicationController
  def index
    @latest_surveys = Survey.order("updated_at asc").last(5).reverse
    @active_users = User.order("contribution_count desc").limit(5)
  end
  
  def about
  end

  def data
  end

  def contact
  end

end
