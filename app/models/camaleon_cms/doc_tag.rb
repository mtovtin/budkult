class CamaleonCms::DocTag < ActiveRecord::Base
	require "babosa"
	extend FriendlyId
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}doc_tags"
	has_many :taggings
	has_many :docs, through: :taggings
	validates :name, uniqueness: true

	friendly_id :name, use: :slugged

	def normalize_friendly_id(input)
		input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
	end
end