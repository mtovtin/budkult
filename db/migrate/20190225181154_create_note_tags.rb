class CreateNoteTags < CamaManager.migration_class
  def change
		create_table "#{PluginRoutes.static_system_info["db_prefix"]}note_tags" do |t|
			t.string   "name"
			t.string   "slug"
		end
  end
end
