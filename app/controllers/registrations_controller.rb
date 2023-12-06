class RegistrationsController < Devise::RegistrationsController
  #disables new signups
  def create
    redirect_to new_user_session_path and return
    super
  end

  def new
    redirect_to new_user_session_path and return
    super
  end

end
