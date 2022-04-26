class CreateRequest < CamaManager.migration_class
	def change
		create_table "#{PluginRoutes.static_system_info["db_prefix"]}request" do |t|
			t.references :site, index: true
			t.text 		 :title
			t.string	 :name
			t.string  	 :request_type
			t.text  	 :content
			t.string     :address
			t.string	 :email

			t.timestamps
		end
	end
end