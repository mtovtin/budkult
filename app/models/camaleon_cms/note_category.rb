class CamaleonCms::NoteCategory < ActiveRecord::Base
	require "babosa"
	extend FriendlyId
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}note_categories"
	has_many :note_cattings
	has_many :notes, through: :note_cattings
	validates :name, uniqueness: true

	friendly_id :name, use: :slugged

	def normalize_friendly_id(input)
		input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
	end
end