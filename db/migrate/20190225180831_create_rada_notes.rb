class CreateRadaNotes < CamaManager.migration_class
	def change
		create_table "#{PluginRoutes.static_system_info["db_prefix"]}notes" do |t|
			t.references :site, index: true
			t.string   "title"
			t.string   "slug", index: true
			t.text     "content",          limit: 1073741823
			t.string   "post_imported_thumb"
			t.string   "status", default: "published", index: true
			t.datetime "published_at"

			t.timestamps
		end
	end
end