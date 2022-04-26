task publish_notes: :environment do
  time = Time.zone.now
  puts time

  notes = CamaleonCms::Note.scheduled.where(created_at: (time - 35.minutes..time + 3.minutes))
  puts "Publishing: #{notes.map(&:title)}" if notes
  notes.update_all(status: 'published')
end