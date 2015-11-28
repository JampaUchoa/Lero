class Room < ActiveRecord::Base
  has_many :chats
  has_many :tenants
  belongs_to :user
end
