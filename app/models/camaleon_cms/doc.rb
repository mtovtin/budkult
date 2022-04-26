class CamaleonCms::Doc < ActiveRecord::Base
	require 'babosa'
	extend FriendlyId
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}docs"
	belongs_to :site, class_name: 'CamaleonCms::Site'
	has_many :categorizations, dependent: :destroy
	has_many :doc_categories, through: :categorizations
	has_many :taggings, dependent: :destroy
	has_many :doc_tags, through: :taggings
	belongs_to :user, class_name: 'CamaleonCms::User'
	validates :counter, uniqueness: true, allow_blank: true
	validates :doc_index, uniqueness: false, allow_blank: true
	validates :mce_doc_number, uniqueness: false, allow_blank: true
	validates :kind, uniqueness: false, allow_blank: true
	validates :source, uniqueness: false, allow_blank: true
	validates :branch, uniqueness: false, allow_blank: true
	validates :doc_stamp, uniqueness: false, allow_blank: true

	# filter by title
	scope :by_title, -> (query) { where('lower(title) like ?', "%#{query}%") }
	# filter by doc_number
	scope :by_doc_number, -> (query) { where('doc_index = ? OR mce_doc_number = ?', query, query) }
	# finds documents that were created between the specified start and end dates
	scope :by_doc_created_at_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }
	# filter by doc document kind
	scope :by_doc_kind, -> (query) { where('kind =?', query) }
	# filter by doc document branch
	scope :by_doc_branch, -> (query) { where('branch =?', query) }
	# filter by doc document source
	scope :by_doc_source, -> (query) { where('source =?', query) }
	store_accessor :options, :show_updated

	enum doc_type: {
		'Без шапки' => 0,
		'Рішення виконкому' => 1,
		'Рішення сесій' => 2
	}

	friendly_id :title, use: :slugged

	def normalize_friendly_id(input)
		input.to_s.to_slug.normalize(transliterations: :ukrainian).to_s
	end

	scope :published, lambda {
		where(:status => 'published')
	}

	def self.tagged_with(slug)
		CamaleonCms::DocTag.find_by!(slug: slug).docs.published
	end

	def self.catted_with(slug)
		CamaleonCms::DocCategory.find_by!(slug: slug).docs.published
	end

	def self.tag_counts
		CamaleonCms::DocTag.select('doc_tags.*, count(taggings.doc_tag_id) as count').joins(:taggings).group('taggings.doc_tag_id')
	end

	def tag_list
		doc_tags.map(&:name).join(', ')
	end

	def tag_list=(names)
		self.doc_tags = names.split(',').map do |n|
			CamaleonCms::DocTag.where(name: n.strip).first_or_create!
		end
	end

	def cat_list
		doc_categories.map(&:name).join(', ')
	end

	def cat_list=(names)
		self.doc_categories = names.split(',').map do |n|
			CamaleonCms::DocCategory.where(name: n.strip).first_or_create!
		end
	end
end