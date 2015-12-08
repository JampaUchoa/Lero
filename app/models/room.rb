class Room < ActiveRecord::Base

  mount_uploader :photo, RoomPhotoUploader

  has_many :chats
  has_many :tenants, dependent: :destroy
  belongs_to :user

  before_create{
    self.slug = self.name.parameterize
    self.name.squish!
  }
  validates :name, length: {minimum: 2, maximum: 15 },
                   uniqueness: { case_sensitive: false }

  validates :slug, uniqueness: { case_sensitive: false }

  validates :description, length: { maximum: 40 }

end
