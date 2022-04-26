class AddMceToDocs < ActiveRecord::Migration[5.2]
  def change
  	add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :doc_type, :integer
  	add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :mce_session_number, :string
  	add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :mce_forum_number, :string
  	add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :mce_text, :string
  	add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :mce_date, :date
  	add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :mce_doc_number, :string
  end
end