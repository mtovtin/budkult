Rails.application.routes.draw do
  post '/chat' => 'chat#chat'
  get '/chat_cfg' => 'chat#chat_config'
	post '/filter' => 'public#filter'
	get '/documents' => 'public#index'
	get '/download_file' => 'public#download'
	scope PluginRoutes.system_info['relative_url_root'], as: 'cama' do
		scope module: 'camaleon_cms', as: 'cama' do
			namespace :admin, path: PluginRoutes.system_info["admin_path_name"] do
				get 'requests' => 'requests#index'
				get 'requests/:id' => 'requests#show'
				get 'doc_tags' => 'docs#doc_tag_list'
				get 'doc_cats' => 'docs#doc_cat_list'
				get 'doc_spcats' => 'docs#doc_spcat'
				get 'recent_tags' => 'notes#recent_tags'
				get 'note_tags' => 'notes#note_tag_list'
				get 'notes/category/:id' => 'notes#tax_category_notes'
				get 'notes/tag/:id' => 'notes#tax_tag_notes'
				get 'docs/category/:id' => 'docs#tax_category_docs'
				get 'docs/tag/:id' => 'docs#tax_tag_docs'
				post 'import/' => 'docs#import'
				scope :docs do
					get 'category_autocompletion' => 'docs#doc_cat_autocomplete'
					resources :doc_categories
					resources :doc_tags
					resources :docs do
						collection do
							delete 'destroy_multiple'
						end
					end
				end
				scope :notes do
					resources :note_categories
					resources :note_tags
				end
				resources :requests, only: [:destroy]
				resources :docs, only: [:destroy, :show, :update, :create, :edit, :index, :new]
				resources :notes, only: [:destroy, :show, :update, :create, :edit, :index, :new]
				resources :petitions
				get 'requests/new/pub' => 'requests#pub_request'
				get 'requests/new/req' => 'requests#req_request'
				
			end
		end
		controller 'camaleon_cms/frontend' do
			post 'save_request' => :save_request, as: :save_request
			get 'post/:slug' => :post_item, as: :post_item, :constraints => { :slug => /[^\/]+/ }
			get 'petition/:slug' => :petition_item, as: :petition_item, :constraints => { :slug => /[^\/]+/ }
			get 'petitions/cat/archive' => :petitions_archive, as: :petitions_archive
			get 'petitions/cat/answer' => :petitions_answer, as: :petitions_answer
			get 'rada_docs/:tag' => :doc_tag, as: :doc_tag, :constraints => { :tag => /[^\/]+/ }
			get 'rada_docs/show/:title' => :show_docs_items, as: :show_docs_items, :constraints => { :title => /[^\/]+/ }
			get 'category/:title' => :my_category, as: 'new_category', constraints: -> (request) {
				request.params[:title].match(/[a-zA-Z0-9_=\s\-\/]+/)
			}
			get 'tag/:title' => :my_post_tag, as: 'new_tag', constraints: -> (request) {
				request.params[:title].match(/[a-zA-Z0-9_=\s\-\/]+/)
			}
			get 'archive/:year/:month/:day' => :post_archive, as: 'archive_post', constraints: -> (request) {
				request.params[:year].match(/[0-9]+/)
			}
			get 'archive/:year/:month' => :post_archive_month, as: 'archive_post_month', constraints: -> (request) {
				request.params[:year].match(/[0-9]+/)
			}
			get 'archive/:year' => :post_archive_year, as: 'archive_post_year', constraints: -> (request) {
				request.params[:year].match(/[0-9]+/)
			}
			get 'archive/router' => :post_archive_router, as: 'archive_post_router'
			get 'search' => :search, as: 'search_new'
			get ':slug' => :post, as: 'archive_post_item', constraints: ->(request) {
				request.params[:slug].match(/[a-zA-Z0-9_=\s\-\/]+/)
			}
		end
  end
end