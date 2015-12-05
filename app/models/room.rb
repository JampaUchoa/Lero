class Room < ActiveRecord::Base
  has_many :chats
  has_many :tenants, dependent: :destroy
  belongs_to :user

  before_create{
    self.slug = self.name.parameterize
  }
  validates :name, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: { case_sensitive: false }

end
