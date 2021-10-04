class RemoveRequesttypeFromRequests < ActiveRecord::Migration[5.2]
  def change
  	remove_column "#{PluginRoutes.static_system_info["db_prefix"]}request", :request_type
  end
end