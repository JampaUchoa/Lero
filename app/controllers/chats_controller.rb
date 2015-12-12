class ChatsController < ApplicationController
  include ApplicationHelper
  def sendmsg
    if logged_in && !current_user.username.nil?
      room_id = (params[:roomId])
      @message = (params[:message])
      link = (params[:link])

      tenancy = Tenant.find_by(user_id: current_user.id, room_id: room_id)
      if tenancy
        if !tenancy.banned && current_user.banned_at.nil?
          @chat = Chat.new(user_id: current_user.id, message: @message, room_id: room_id)

          if link.present?
            begin
                a = Mechanize.new
                a.user_agent_alias = "Windows Chrome"
                a.get(link)
              case a.page.response['content-type'].to_s
              when "image/gif", "image/jpg", "image/png", "image/jpeg"
                if a.page.response['content-length'].to_i < 3.megabytes
                  @chat.media_type = 1
                  @chat.remote_image_content_url = link
                  @chat.message = @message.gsub(link, "")
                end
              when "video/mp4", "video/webm"
                if link.starts_with?('http://i.imgur.com/', 'https://i.imgur.com/', 'i.imgur.com/', 'http://imgur.com/')
                  @chat.remote_image_content_url = link.gsub(/\b.webm\b/, "h.jpg").gsub(/\b.mp4\b/, "h.jpg")
                end
                if link["gfycat.com/"]
                  @chat.remote_image_content_url = link.gsub(/\bgiant.\b/, "thumbs.").gsub(/\bfat.\b/, "thumbs.").gsub(/\bzippy.\b/, "thumbs.").gsub(/\b.webm\b/, "-poster.jpg").gsub(/\b.mp4\b/, "-poster.jpg")
                end
                @chat.media_type = 2
                @chat.video_content = link
                @chat.message = @message.gsub(link, "")
              end
            rescue => e
              #
            end
          end

          @chat.save
          render json: {status: "success"}
        else
          render json: {status: "forbidden"}
        end
      else
        render json: {status: "notFound"}
      end
    end
  end

  def receive
    if logged_in
      lastmsg = (params[:id]).to_i
      usertenancy = current_user.tenancies.where(active: true).pluck(:room_id)
      if usertenancy.any?
        if lastmsg == 0
          @newchats = []
          current_user.tenancies.where(active: true).includes(:room).each do |j|
            j.room.chats.includes(:user).order("id ASC").last(100).each do |c|
              @newchats << c
            end
          end
        else
          @newchats = Chat.where('id > ?', lastmsg).where(room_id: usertenancy).order("id ASC").last(50)
        end
        @chatmsgs = messagefy(@newchats)
      end
      render json: @chatmsgs
    end
  end

end
