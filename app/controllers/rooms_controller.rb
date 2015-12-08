class RoomsController < ApplicationController
  def create
    if logged_in
      @room = Room.new(room_params)
      @room.user_id = current_user.id

    # onwership = Subscription.where(user_id: current_user.id, community_id: @room.community_id, moderador: true).first
    # Deny unless !onwership.nil?
    # Cover community nil cases

      if @room.save
        Tenant.create(user_id: current_user.id, room_id: @room.id, moderator: true)
      end
    end
  end

  def join
    @room_id = (params[:id])
    if current_user
      subscribed = Tenant.find_by(user_id: current_user.id, room_id: @room_id)
      if subscribed
        subscribed.update_attribute(:active, true)
      else
        Tenant.create(user_id: current_user.id, room_id: @room_id)
      end
    end
    render json: {}
  end

  def leave
    @room_id = (params[:id])
    if current_user
      to_destroy = Tenant.find_by(user_id: current_user.id, room_id: @room_id)
      to_destroy.update_attribute(:active, false)
    end
    render json: {}
  end

  def ban
    @room_id = (params[:roomId])
    @user_id = (params[:userId])
    if current_user
      mod_check = Tenant.find_by(user_id: current_user.id, room_id: @room_id, moderator: true)
      if !mod_check.nil?
        to_ban = Tenant.find_by(user_id: @user_id, room_id: @room_id, moderator: false)
        if to_ban
          to_ban.update_attribute(:banned, true)
          render json: {status: "success"}
        else
          render json: {status: "notFound"}
        end
      else
        render json: {status: "forbidden"}
      end
    end
  end

  def makemod
    @room_id = (params[:roomId])
    @user_id = (params[:userId])
    if current_user
      mod_check = Tenant.find_by(user_id: current_user.id, room_id: @room_id, moderator: true)
      if !mod_check.nil?
        to_mod = Tenant.find_by(user_id: @user_id, room_id: @room_id, moderator: false)
        if to_mod
          to_mod.update_attribute(:moderator, true)
        end
      end
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
