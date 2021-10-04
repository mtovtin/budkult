class CreateNoteTaggings < CamaManager.migration_class
	def change
		create_table  "#{PluginRoutes.static_system_info["db_prefix"]}note_taggings" do |t|
			t.integer :note_id
			t.integer :note_tag_id

			t.timestamps
		end

		add_index "#{PluginRoutes.static_system_info["db_prefix"]}note_taggings", [:note_id, :note_tag_id]
	end
end