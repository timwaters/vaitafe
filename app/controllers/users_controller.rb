class UsersController < ApplicationController

  before_action :authenticate_user!

  #TODO Pagination, sorting etc
  def index
    @users = User.order("contribution_count desc").page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @surveys = @user.surveys
  end

end