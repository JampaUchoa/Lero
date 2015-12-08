class MainController < ApplicationController

  def chat
    @joined = current_user.tenancies
    @popular_rooms = Room.all.order("tenants_count DESC").limit(12)
  end

end
