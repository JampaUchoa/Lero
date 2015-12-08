class UsersController < ApplicationController

  def set_name
    @user = current_user
    if @user && !@user.username_set
      @user.username_set = true
      @user.name = (params[:user][:username])
      if @user.update_attributes(username_params)
        #
      end
    else
      return
    end
  end

  def set_password
    @user = current_user
    if @user && @user.password.nil?
      if @user.update_attributes(password_params)
        #
      end
    end
  end

  def set_profile
    @user = current_user
    if @user
      if @user.update_attributes(profile_params)
        #
      end
    end
  end

  def hello
    current_user.update_attribute(:online, true)
    current_user.update_attribute(:last_call, Time.now)
    current_user.increment!(:sessions_count)

    render json: {}
  end

  def goodbye
    current_user.update_attribute(:last_call, Time.now)
    current_user.decrement!(:sessions_count)

    if current_user.sessions_count >= 0
      current_user.update_attribute(:online, false)
    end

    render json: {}
  end


  private
  def username_params
    params.require(:user).permit(:username)
  end

  def password_params
    params.require(:user).permit(:password)
  end

  def profile_params
    params.require(:user).permit(:password, :photo, :name, :bio)
  end

end
