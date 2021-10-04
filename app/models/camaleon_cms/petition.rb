class CamaleonCms::Petition < ActiveRecord::Base
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}petitions"
	belongs_to :site, class_name: 'CamaleonCms::Site'
end