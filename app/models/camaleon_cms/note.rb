class CamaleonCms::Note < ActiveRecord::Base
	require "babosa"
	extend FriendlyId
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}notes"
	belongs_to :site, class_name: 'CamaleonCms::Site'
	has_many :note_cattings, dependent: :destroy
	has_many :note_categories, through: :note_cattings
	has_many :note_taggings, dependent: :destroy
	has_many :note_tags, through: :note_taggings
	belongs_to :user, class_name: 'CamaleonCms::User'

	store_accessor :options, :hide_title, :hide_thumb, :show_updated

	friendly_id :title, use: :slugged

	def normalize_friendly_id(input)
		input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
	end

	scope :published, -> { where(status: 'published') }
	scope :scheduled, -> { where(status: 'scheduled') }

	def self.tagged_with(slug)
		CamaleonCms::NoteTag.find_by!(slug: slug).notes.published
	end

	def self.catted_with(slug)
		CamaleonCms::NoteCategory.find_by!(slug: slug).notes.published
	end

	def self.tag_counts
		CamaleonCms::NoteTag.select("rdauzh_note_tags.*, COUNT(rdauzh_note_taggings.id) AS t_count").joins(:note_taggings).group("rdauzh_note_tags.id")
	end

	def tag_list
		note_tags.map(&:name).join(', ')
	end

	def tag_list=(names)
		self.note_tags = names.split(',').map do |n|
			CamaleonCms::NoteTag.where(name: n.strip).first_or_create!
		end
	end

	def cat_list
		note_categories.map(&:name).join(', ')
	end

	def cat_list=(names)
		self.note_categories = names.split(',').map do |n|
			CamaleonCms::NoteCategory.where(name: n.strip).first_or_create!
		end
	end
end