class AddSliderImagesToNotes < ActiveRecord::Migration[5.2]
	def change
		add_column "#{PluginRoutes.static_system_info["db_prefix"]}notes", :slider_images, :text
	end
end