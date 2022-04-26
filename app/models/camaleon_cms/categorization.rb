class CamaleonCms::Categorization < ActiveRecord::Base
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}categorizations"
	belongs_to :doc
	belongs_to :doc_category
end