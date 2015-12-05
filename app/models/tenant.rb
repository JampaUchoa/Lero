class Tenant < ActiveRecord::Base
  belongs_to :room
  belongs_to :user, required: true
end
