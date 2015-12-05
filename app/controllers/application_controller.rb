class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale
  before_filter :join_via_hotilink

  include SessionsHelper

  def set_locale
    if !logged_in
      @user = User.new
      require "geoip"
      g = GeoIP.new("GeoLiteCity.dat").city(request.remote_ip)
      if !g.nil?
        @user.latitude = g.latitude
        @user.longitude = g.longitude
      end
      @user.username = rand(1000..999999999999999)
      @user.save!
      log_in @user
      Tenant.create(user_id: current_user.id, room_id: 1)
      remember(@user)
    end
  end

  def join_via_hotilink
    if params[:join].present?
      directroom = Room.find_by(slug: params[:join].to_s)
      if !directroom.nil?
        Tenant.first_or_create(user_id: current_user.id, room_id: directroom.id)
        cookies.permanent[:lastRoom] = directroom.id
      end
    end
  end

end
