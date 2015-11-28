class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale

  include SessionsHelper

  def set_locale
    if !logged_in
  #    require "geoip"
  #    g = GeoIP.new("GeoLiteCity.dat").city(request.remote_ip)
      @user = User.create
      remember(@user)
      log_in @user
    end
  end

end
