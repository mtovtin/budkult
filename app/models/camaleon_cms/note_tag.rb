class CamaleonCms::NoteTag < ActiveRecord::Base
	require "babosa"
	extend FriendlyId
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}note_tags"
	has_many :note_taggings
	has_many :notes, through: :note_taggings
	validates :name, uniqueness: true

	friendly_id :name, use: :slugged

	def normalize_friendly_id(input)
		input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
	end
end