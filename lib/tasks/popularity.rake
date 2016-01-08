task :popularity => :environment do
# ranks room from popular, needs to be more soft
  Room.all.each do |r|
    score = 0
    score += Chat.where(room_id: r.id).where("created_at >= ?", 2.minutes.ago).count * 30
    score += Chat.where(room_id: r.id).where("created_at >= ?", 10.minutes.ago).count * 20
    score += Chat.where(room_id: r.id).where("created_at >= ?", 1.hours.ago).count   * 10
    score += Chat.where(room_id: r.id).where("created_at >= ?", 6.hours.ago).count   * 7
    score += Chat.where(room_id: r.id).where("created_at >= ?", 24.hours.ago).count  * 5
    r.update_attribute(:popularity, score)
  end

end
