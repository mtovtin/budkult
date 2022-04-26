class AddOptionsToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :options, :json, default: {}
  end
end
