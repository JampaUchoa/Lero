class ChatsController < ApplicationController

  def sendmsg
    if logged_in && !current_user.username.nil?
      room_id = (params[:roomId])
      @message = (params[:message])
      link = (params[:link])

      tenancy = Tenant.find_by(user_id: current_user.id, room_id: room_id)
      if tenancy
        if !tenancy.banned
          @chat = Chat.new(user_id: current_user.id, message: @message, room_id: room_id)

            begin
                a = Mechanize.new
                a.user_agent_alias = "Windows Chrome"
                a.get(link)
              case a.page.response['content-type'].to_s
              when "image/gif", "image/jpg", "image/png", "image/jpeg"
                @chat.media_type = 1
                @chat.remote_image_content_url = link
              end
            rescue => e

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
            j.room.chats.includes(:user).order("id ASC").last(150).each do |c|
              @newchats << c
            end
          end
        else
          @newchats = Chat.where('id > ?', lastmsg).where(room_id: usertenancy).where.not(user_id: current_user.id).order("id ASC").last(50)
        end
        @chatmsgs = Array.new
        @newchats.each do |m|
          @chatmsgs << {
            id: m.id,
            message: markdown(m.message),
            room: m.room_id,
            created_at: m.created_at.utc.to_i*1000,
            userid: m.user.id,
            username: h(m.user.name),
            photo:
            if m.user.photo?
              m.user.photo.url.to_s
            end
          }
        end
      end
      render json: @chatmsgs
    end
  end

  def markdown(text)
    options = {
      filter_html:     true,
      no_images:       true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }
    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }
    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end

end
