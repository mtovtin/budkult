class CreateNoteCattings < CamaManager.migration_class
	def change
		create_table  "#{PluginRoutes.static_system_info["db_prefix"]}note_cattings" do |t|
			t.integer :note_id
			t.integer :note_category_id

			t.timestamps
		end

		add_index "#{PluginRoutes.static_system_info["db_prefix"]}note_cattings", [:note_id, :note_category_id]
	end
end