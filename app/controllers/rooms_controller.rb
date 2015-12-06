class RoomsController < ApplicationController
  def create
    if logged_in
      @room = Room.new(room_params)
      @room.user_id = current_user.id

    # onwership = Subscription.where(user_id: current_user.id, community_id: @room.community_id, moderador: true).first
    # Deny unless !onwership.nil?
    # Cover community nil cases

      if @room.save
        Tenant.create(user_id: current_user.id, room_id: @room.id)
      end
    end
  end

  def join
    @room = (params[:id])
    if current_user
      Tenant.create(user_id: current_user.id, room_id: @room)
    end
    render json: {}
  end

  def leave
    @room = (params[:id])
    if current_user
      to_destroy = Tenant.find_by(user_id: current_user, room_id: @room)
      to_destroy.destroy if !to_destroy.nil?
    end
    render json: {}
  end

  def share
    @room = (params[:id])
    if current_user
      to_share = Tenant.find_by(user_id: current_user, room_id: @room)
    end
    render json: {shareurl: to_share.room.slug}
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :photo)
  end
end
