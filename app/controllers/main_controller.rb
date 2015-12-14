class MainController < ApplicationController

  def chat
    @joined = current_user.tenancies.where(active: true).includes(:room)
    @popular_rooms = Room.all.order("popularity DESC").limit(12)
  end

end
