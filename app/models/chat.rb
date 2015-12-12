class Chat < ActiveRecord::Base
  mount_uploader :image_content, ChatMediaUploader
  belongs_to :room, counter_cache: true, required: true
  belongs_to :user

end
