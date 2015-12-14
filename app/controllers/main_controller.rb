class MainController < ApplicationController

  def chat
    @joined = current_user.tenancies.where(active: true).includes(:room)
    @popular_rooms = Room.all.order("chats_count * tenants_count DESC").limit(12)
  end

end
