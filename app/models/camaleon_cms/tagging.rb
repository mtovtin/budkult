class CamaleonCms::Tagging < ActiveRecord::Base
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}taggings"
	belongs_to :doc
	belongs_to :doc_tag
end