class CreateDocsCategories < CamaManager.migration_class
	def change
		create_table "#{PluginRoutes.static_system_info["db_prefix"]}doc_categories" do |t|
			t.string   "name"
			t.string   "slug"
		end
	end
end