class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale

  include SessionsHelper

  def set_locale
    if !logged_in
      @user = User.new
      require "geoip"
      g = GeoIP.new("GeoLiteCity.dat").city(request.remote_ip)
      if !g.nil?
        @user.latitude = g.latitude
        @user.longitude = g.longitude
        if g.country_code2.downcase == ("br" || "pt")
          cookies.permanent[:locale] = "pt-BR"
        else
          cookies.permanent[:locale] = "en"
        end
      else
        cookies.permanent[:locale] = "en"
      end
      @user.language = I18n.locale = cookies.permanent[:locale] || "en"
      @user.name = @user.username = rand(1000..999999999999999)
      @user.ip_address = request.remote_ip
      @user.save!
      log_in @user
      remember(@user)
    end
  end

end
