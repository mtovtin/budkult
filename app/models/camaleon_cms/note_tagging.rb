class CamaleonCms::NoteTagging < ActiveRecord::Base
	self.table_name = "#{PluginRoutes.static_system_info['db_prefix']}note_taggings"
	belongs_to :note
	belongs_to :note_tag
end