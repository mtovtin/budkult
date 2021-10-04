class CamaleonCms::NoteCatting < ActiveRecord::Base
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}note_cattings"
	belongs_to :note
	belongs_to :note_category
end