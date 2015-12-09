class Chat < ActiveRecord::Base

  mount_uploader :image_content, ChatMediaUploader

  belongs_to :room
  belongs_to :user
end
