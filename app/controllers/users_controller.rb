class UsersController < ApplicationController

  def update
    @user = User.find(params[:id])
    if @user == current_user && !@user.username_set
      @user.username_set = true
      if @user.update_attributes(user_params)
        #
      else
        #
      end
    else
      # Invalid
    end
  end

  def set_name
    @user = current_user
    if @user && !@user.username_set
      @user.username_set = true
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

  private
  def username_params
    params.require(:user).permit(:username)
  end

  def password_params
    params.require(:user).permit(:password)
  end

  def profile_params
    params.require(:user).permit(:password, :photo)
  end

end
