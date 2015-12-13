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
      if !@user.username_set
        @user.username_set = true
        @user.name = (params[:user][:username])
        @user.update_attributes(username_params)
        if @user.update_attributes(username_params)
          #
        end
      else
        if @user.update_attributes(profile_params)
          #
        end
      end
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def wipe
    @user = User.find_by(id: params[:id])
    if current_user && current_user.admin?
      @user.banned_at = Time.now
      @user.chats.destroy_all
      @user.rooms.destroy_all
      @user.save
    end
    render js: "alert('banned')"
  end

  def hello
    @user = current_user

    require "geoip"
    g = GeoIP.new("GeoLiteCity.dat").city(request.remote_ip)
    if !g.nil?
      @user.latitude = g.latitude
      @user.longitude = g.longitude
    end
    @user.ip_address = request.remote_ip
    
    @user.online = true
    @user.last_call = Time.now
    @user.sessions_count += 1
    @user.save
    render json: {}
  end

  def goodbye
    @user = current_user
    @user.last_call = Time.now
    @user.sessions_count -= 1

    if current_user.sessions_count <= 0
      @user.online = false
    end

    @user.save
    render json: {}
  end


  private
  def username_params
    params.require(:user).permit(:username, :photo, :name, :bio)
  end

  def password_params
    params.require(:user).permit(:password)
  end
  def profile_params
    params.require(:user).permit(:photo, :name, :bio)
  end

end
