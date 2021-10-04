class AddOptionsToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column "#{PluginRoutes.static_system_info["db_prefix"]}notes", :options, :json, default: {}
    add_column "#{PluginRoutes.static_system_info["db_prefix"]}posts", :options, :json, default: {}
  end
end
