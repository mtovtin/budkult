class AddUserIdToDocs < ActiveRecord::Migration[5.2]
  def change
    add_column "#{PluginRoutes.static_system_info["db_prefix"]}docs", :user_id, :integer
  end
end
