class CreatePetitions < CamaManager.migration_class
	def change
		create_table "#{PluginRoutes.static_system_info["db_prefix"]}petitions" do |t|
			t.references :site, index: true
			t.string   "title"
			t.string   "number"
			t.string   "author"
			t.string   "deadline"
			t.integer  "votes_need", default: 0
			t.integer  "real_votes", default: 0
			t.string   "slug", index: true
			t.text     "content",         limit: 1073741823
			t.text     "voters",          limit: 1073741823
			t.text     "answer",          limit: 1073741823
			t.string   "status_answer", default: "default"
			t.string   "status_archive", default: "default"
			
			t.timestamps
		end
	end
end