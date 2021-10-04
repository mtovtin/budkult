class CreateRadaDocs < CamaManager.migration_class
    def change
        create_table "#{PluginRoutes.static_system_info["db_prefix"]}docs" do |t|
            t.references :site, index: true
            t.string   "title"
            t.string   "slug", index: true
            t.text     "content",          limit: 1073741823
            t.string   "rada_docs_url"
            t.string   "status", default: "published", index: true
            t.datetime "published_at"

            t.timestamps
        end
    end
end