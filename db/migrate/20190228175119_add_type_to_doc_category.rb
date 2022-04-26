class AddTypeToDocCategory < ActiveRecord::Migration[5.2]
  def change
  	add_column "#{PluginRoutes.static_system_info["db_prefix"]}doc_categories", :doc_type, :string, default: "nope"
  end
end
