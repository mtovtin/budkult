class CreateTaggings < CamaManager.migration_class
	def change
		create_table  "#{PluginRoutes.static_system_info["db_prefix"]}taggings" do |t|
			t.integer :doc_id
			t.integer :doc_tag_id

			t.timestamps
		end

		add_index "#{PluginRoutes.static_system_info["db_prefix"]}taggings", [:doc_id, :doc_tag_id]
	end
end