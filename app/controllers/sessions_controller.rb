class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_url
    end
  end

  def create
    login_info = params[:session][:username].downcase

    user = User.find_by(username: login_info) || User.find_by(email: login_info)

    if user && user.authenticate(params[:session][:password])
      log_in user
      remember(user)
      @autenticated = true;
    else
      @autenticated = false;
    end
  end

  def destroy
    log_out if logged_in
    redirect_to '/'
  end
end
