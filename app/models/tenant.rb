class Tenant < ActiveRecord::Base
  belongs_to :room, counter_cache: true, required: true
  belongs_to :user, required: true
end
