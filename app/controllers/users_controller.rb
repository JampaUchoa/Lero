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

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end

end
