# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( jquery.gridly.css )
Rails.application.config.assets.precompile += %w( jquery.gridly.js )
Rails.application.config.assets.precompile += %w( moment.js )
Rails.application.config.assets.precompile += %w( daterangepicker.js )
Rails.application.config.assets.precompile += %w( daterangepicker.css )
Rails.application.config.assets.precompile += %w( daterangepicker_initializer )
Rails.application.config.assets.precompile += %w( document_search_ajax )
Rails.application.config.assets.precompile += %w( import_form.css )
Rails.application.config.assets.precompile += %w( import_form.js )
Rails.application.config.assets.precompile += %w( adm_docs_grid.js )
Rails.application.config.assets.precompile += %w( chat.css )
Rails.application.config.assets.precompile += %w( chat/chat.js )
Rails.application.config.assets.precompile += %w( chat/chat_init.js )
Rails.application.config.assets.precompile += %w( chat/fp2.js )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
