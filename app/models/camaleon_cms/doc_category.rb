class CamaleonCms::DocCategory < ActiveRecord::Base
	require "babosa"
	extend FriendlyId
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}doc_categories"
	has_many :categorizations
	has_many :docs, through: :categorizations
	validates :name, uniqueness: true
	scope :special, -> {
		where(:doc_type => 'special')
	}
	scope :not_special, -> {
		where(:doc_type => 'nope')
	}
	friendly_id :name, use: :slugged

	def normalize_friendly_id(input)
		input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
	end

	def self.autocomplete_search(search_query)
		suggestions = where("LOWER(name) LIKE ?", "%#{search_query}%").order("id desc").limit(10).pluck(:id, :name)
		suggestions.collect {|suggestion| {"label" => suggestion[1], "value" => suggestion[0] }}
	end
end