class CreateCategorizations < CamaManager.migration_class
	def change
		create_table  "#{PluginRoutes.static_system_info["db_prefix"]}categorizations" do |t|
			t.integer :doc_id
			t.integer :doc_category_id

			t.timestamps
		end

		add_index "#{PluginRoutes.static_system_info["db_prefix"]}categorizations", [:doc_id, :doc_category_id]
	end
end