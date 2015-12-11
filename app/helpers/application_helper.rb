module ApplicationHelper
  def messagefy(relation)
    messages = Array.new
    relation.each do |m|
      messages << {
        id: m.id,
        message: markdown(m.message),
        room: m.room_id,
        created_at: m.created_at.utc.to_i*1000,
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
end
