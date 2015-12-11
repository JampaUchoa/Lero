class MainController < ApplicationController

  def chat
    @joined = current_user.tenancies.where(active: true).includes(:room)
    @popular_rooms = Room.where.not(nsfw: true).order("tenants_count DESC").limit(12)
  end

end
