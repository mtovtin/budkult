class CamaleonCms::Request < ActiveRecord::Base
	before_validation :new_title
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}request"
	belongs_to :site, class_name: 'CamaleonCms::Site'
	validates :name, presence: true

	def new_title
		self.title = "Електронне звернення - #{name} #{address} #{email}"
	end
end