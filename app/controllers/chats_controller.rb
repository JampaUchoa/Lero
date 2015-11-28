class ChatsController < ApplicationController

    def sendmsg
      if logged_in && !current_user.username.nil?
        room_id = (params[:roomId])
        @message = (params[:message])
        Chat.create(user_id: current_user.id, message: @message, room_id: room_id)
        render json: {}
      end
    end

    def receive
      if logged_in
        lastmsg = (params[:id]).to_i
        usertenancy = current_user.tenancies.pluck(:room_id)
        if usertenancy.any?
          @newchats = Chat.where('id > ?', lastmsg).where(room_id: usertenancy).last(30)
          @chatmsgs = Array.new
          @newchats.each do |m|
            @chatmsgs << {
              id: m.id,
              message: markdown(m.message),
              room: m.room_id,
              created_at: m.created_at.utc.to_i*1000,
              userid: m.user.username,
              username: m.user.username,
              photo:
              #if m.user.photo?
              #  m.user.photo.to_s
              #else
                ActionController::Base.helpers.asset_path('user-default.png')
              #end
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
