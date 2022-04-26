class AddIsEnabledToNoteCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}note_categories", :is_enabled, :boolean, default: true
  end
end
