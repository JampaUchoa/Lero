class MainController < ApplicationController

  def chat
    @joined = current_user.tenancies.where(active: true).includes(:room)
    @popular_rooms = Room.where.not(nsfw: true).order("created_at DESC").limit(12)
  end

end
