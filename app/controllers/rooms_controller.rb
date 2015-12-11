class RoomsController < ApplicationController
  include ApplicationHelper
  def create
    if logged_in
      @room = Room.new(room_params)
      @room.user_id = current_user.id
      if @room.save
        Tenant.create(user_id: current_user.id, room_id: @room.id, moderator: true)
      end
    end
  end

  def directjoin
    directroom = Room.find_by(slug: params[:id].to_s)
    if !directroom.nil?
      subscribed = Tenant.find_by(user_id: current_user.id, room_id: directroom.id)
      if subscribed
        subscribed.update_attribute(:active, true)
      else
        Tenant.create(user_id: current_user.id, room_id: directroom.id)
      end

      if !current_user.username_set
        current_user.update_attribute(:referral, "Direct Join: #{directroom.name}")
      end
      cookies.permanent[:lastRoom] = directroom.id
    end
    redirect_to root_url
  end

  def join
    room_id = (params[:id]).to_i
    @room = Room.find_by(id: room_id)
    if current_user && @room
      subscribed = Tenant.find_by(user_id: current_user.id, room_id: room_id)
      if subscribed
        subscribed.update_attribute(:active, true)
      else
        Tenant.create(user_id: current_user.id, room_id: room_id)
      end
      last_massages = @room.chats.order('id ASC').includes(:user).last(150)
      @response = messagefy(last_massages)
    end
    render json: @response
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

  def edit
    room_id = (params[:id]).to_s

    @room = Room.find_by(id: room_id)
    if current_user
      @mod_check = Tenant.find_by(user_id: current_user.id, room_id: room_id, moderator: true)
    end
  end

  def update
    @room = Room.find_by(id: params[:id])
    if @room
      if @room.update_attributes(room_edit_params)
        #
      end
    end
    render js: "location.reload();"
  end

  private

  def room_params
    params.require(:room).permit(:name, :description, :photo)
  end

  def room_edit_params
    params.require(:room).permit(:description, :photo, :details)
  end
end
