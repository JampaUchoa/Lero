module ApplicationHelper
  def messagefy(relation)
    messages = Array.new
    relation.each do |m|
      messages << {
        id: m.id,
        message: emojify(markdown(m.message)) || "", # hack to prevent "null" coming on images
        room: m.room_id,
        created_at: m.created_at.utc.to_i*1000, # we make like this so js can read it
        userid: m.user.id,
        username: h(m.user.name),
        photo: m.user.photo.url.to_s,
        media_type: m.media_type,
        image_content: m.image_content.url.to_s,
        video_content: m.video_content
      }
    end
    return messages
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

  def emojify(content) #doesnt work on unicode, needs to be uniform
    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      if emoji = Emoji.find_by_alias($1)
        %(<img alt="#$1" src="#{ActionController::Base.helpers.asset_path("emoji/#{emoji.image_filename}")}" style="vertical-align:middle" width="20" height="20" />)
      else
        match
      end
    end.html_safe if content.present?
  end

end
