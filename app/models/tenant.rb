class Tenant < ActiveRecord::Base
  belongs_to :room, dependent: :destroy
  belongs_to :user, required: true
end
