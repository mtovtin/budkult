class CamaleonCms::FrontendController < CamaleonCms::CamaleonController
	before_action :init_frontent
	include CamaleonCms::FrontendConcern
	include CamaleonCms::Frontend::ApplicationHelper
	layout Proc.new { |controller| args = {layout: (params[:cama_ajax_request].present? ? "cama_ajax" : PluginRoutes.static_system_info['default_layout']), controller: controller}; hooks_run("front_default_layout", args); args[:layout] }

	before_action :before_hooks
	after_action :after_hooks

	skip_before_action :verify_authenticity_token, :only => [:save_request]

	def index
		@cama_visited_home = true
		if @_site_options[:home_page].present?
			render_post(@_site_options[:home_page].to_i)
		else
			r = {layout: nil, render: "index"}; hooks_run("on_render_index", r)
			render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
		end
	end

	def post_item
		@post = CamaleonCms::Note.find_by(slug: params[:slug])
	end

	def requests
		@category = current_site.the_full_categories
	end

	def my_post_tag
		begin
			@posts = CamaleonCms::Note.published.tagged_with(params[:title]).paginate(:page => params[:page], :per_page => current_site.front_per_page)
			@post_tag = CamaleonCms::NoteTag.find_by(slug: params[:title])
		rescue 
			return page_not_found
		end
	end

	def my_category
		begin
			@posts = CamaleonCms::Note.published.catted_with(params[:title]).paginate(:page => params[:page], :per_page => current_site.front_per_page)
			@category = CamaleonCms::NoteCategory.find_by(slug: params[:title])
		rescue 
			return page_not_found
		end
	end

	def petition_item
		@petition = CamaleonCms::Petition.find_by(slug: params[:slug])
	end

	def petitions_archive
		@cat = 'Архів петицій'
		@petitions = CamaleonCms::Petition.where("status_archive LIKE ? AND status_answer LIKE ?", "Архів", "default")
		render 'petitions'
	end

	def petitions_answer
		@cat = 'Надана відповідь'
		@petitions = CamaleonCms::Petition.where("status_answer LIKE ?", "Надана відповідь")
		render 'petitions'
	end

	def doc_tag
		require 'will_paginate/array'
		begin
			doc_show = CamaleonCms::Doc.exists?(slug: params[:tag])
			check_docs = CamaleonCms::DocCategory.exists?(slug: params[:tag])
			if doc_show
				redirect_to :action => "show_docs_items", :title => params[:tag]
			elsif check_docs
				@category = CamaleonCms::DocCategory.find_by(slug: params[:tag])
				if params[:start_date] && params[:end_date]
					start_date = Date.parse("#{params[:start_date]}")
					end_date = Date.parse("#{params[:end_date]}")

					docs = CamaleonCms::Doc.catted_with(params[:tag]).where(:created_at => start_date..end_date)
					type_docs = CamaleonCms::Doc.published.where('special_type LIKE ?', "%#{@category.name}%").where(:created_at => start_date..end_date)
					if type_docs.length > 0 && docs.length > 0
						@arr_docs = [docs.to_a, type_docs.to_a].flatten
					else
						if type_docs.length > 0 && docs.length == 0
							@docs = type_docs
						else
							@docs = docs
						end
					end
				else
					docs = CamaleonCms::Doc.catted_with(params[:tag])
					type_docs = CamaleonCms::Doc.published.where('special_type LIKE ?', "%#{@category.name}%")
					if type_docs.length > 0 && docs.length > 0
						@arr_docs = [docs.to_a, type_docs.to_a].flatten
					else
						if type_docs.length > 0 && docs.length == 0
							@docs = type_docs
						else
							@docs = docs
						end
					end
				end
			else
				@category = CamaleonCms::DocTag.find_by(slug: params[:tag])
				if params[:start_date] && params[:end_date]
					start_date = Date.parse("#{params[:start_date]}")
					end_date = Date.parse("#{params[:end_date]}")
					@docs = CamaleonCms::Doc.tagged_with(params[:tag]).where(:created_at => start_date..end_date).paginate(:page => params[:page], :per_page => current_site.front_per_page)
				else
					@docs = CamaleonCms::Doc.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => current_site.front_per_page)
				end
			end
		rescue 
			return page_not_found
		end
	end

	def show_docs_items
		@post = CamaleonCms::Doc.find_by(slug: params[:title])
	end

	def save_request
		request_data = params.require(:request).permit!
		@request = current_site.requests.new(request_data)
		if @request.save
			flash[:notice] = "Дякуємо за звернення!"
			redirect_to '/'
		end
	end

	def request_params
		parameters = params.require(:request)
		parameters.permit(:name, :content, :address, :email)  
	end

	def category
		begin
			@category = current_site.the_full_categories.find_by_slug(params[:title]).decorate
			@post_type = @category.the_post_type
		rescue
			return page_not_found
		end
		@cama_visited_category = @category
		@children = @category.children.no_empty.decorate
		@posts = @category.the_posts.paginate(:page => params[:page], :per_page => current_site.front_per_page).eager_load(:metas)
		r_file = lookup_context.template_exists?("category_#{@category.the_slug}") ? "category_#{@category.the_slug}" : nil
		r_file = lookup_context.template_exists?("post_types/#{@post_type.the_slug}/category") ? "post_types/#{@post_type.the_slug}/category" : nil unless r_file.present?
		r_file = lookup_context.template_exists?("categories/#{@category.the_slug}") ? "categories/#{@category.the_slug}" : 'category' unless r_file.present?

		layout_ = lookup_context.template_exists?("layouts/post_types/#{@post_type.the_slug}/category") ? "post_types/#{@post_type.the_slug}/category" : nil unless layout_.present?
		layout_ = lookup_context.template_exists?("layouts/categories/#{@category.the_slug}") ? "categories/#{@category.the_slug}" : nil unless layout_.present?
		r = {category: @category, layout: layout_, render: r_file}; hooks_run("on_render_category", r)
		render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
	end

	def post_type
		begin
			@post_type = current_site.post_types.find_by_slug(params[:post_type_slug]).decorate
		rescue
			return page_not_found
		end
		@object = @post_type
		@cama_visited_post_type = @post_type
		@posts = @post_type.the_posts.paginate(:page => params[:page], :per_page => current_site.front_per_page).eager_load(:metas)
		@categories = @post_type.categories.no_empty.eager_load(:metas).decorate
		@post_tags = @post_type.post_tags.eager_load(:metas)
		r_file = lookup_context.template_exists?("post_types/#{@post_type.the_slug}") ? "post_types/#{@post_type.the_slug}" : "post_type"
		layout_ = lookup_context.template_exists?("layouts/post_types/#{@post_type.the_slug}") ? "post_types/#{@post_type.the_slug}" : nil
		r = {post_type: @post_type, layout: layout_, render: r_file};  hooks_run("on_render_post_type", r)
		render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
	end

	def post_tag
		begin
			if params[:title].present?
				@post_tag = current_site.post_tags.find_by_slug(params[:title]).decorate
			else
				@post_tag = current_site.post_tags.find(params[:post_tag_id]).decorate
			end
			@post_type = @post_tag.the_post_type
		rescue
			return page_not_found
		end
		@object = @post_tag
		@cama_visited_tag = @post_tag
		@posts = @post_tag.the_posts.paginate(:page => params[:page], :per_page => current_site.front_per_page).eager_load(:metas)
		r_file = lookup_context.template_exists?("post_types/#{@post_type.the_slug}/post_tag") ? "post_types/#{@post_type.the_slug}/post_tag" : 'post_tag'
		layout_ = lookup_context.template_exists?("layouts/post_tag") ? "post_tag" : nil
		r = {post_tag: @post_tag, layout: layout_, render: r_file}; hooks_run("on_render_post_tag", r)
		render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
	end

	def search
		require 'will_paginate/array'
		breadcrumb_add(ct("search"))
		@cama_visited_search = true
		@param_search = params[:q]
		layout_ = lookup_context.template_exists?("layouts/search") ? "search" : nil
		r = {layout: layout_, render: "search", posts: nil}; hooks_run("on_render_search", r)
		params[:q] = (params[:q] || '').downcase

		@docs = current_site.docs.where("LOWER(title) LIKE ?", "%#{params[:q]}%").paginate(:page => params[:page], :per_page => current_site.front_per_page)
		@posts = r[:posts] != nil ? r[:posts] : current_site.notes.where("LOWER(title) LIKE ? OR LOWER(content) LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
		@pages = r[:posts] != nil ? r[:posts] : current_site.the_posts.where("LOWER(title) LIKE ? OR LOWER(content) LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
		@posts_size = @posts.size

		@posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page)
		@pages = @pages.paginate(:page => params[:page], :per_page => current_site.front_per_page)
		
		render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
	end

	def ajax
		r = {render_file: nil, render_text: "", layout: nil }
		@cama_visited_ajax = true
		hooks_run("on_ajax", r)
		if r[:render_file]
			render r[:render_file], (!r[:layout].nil? ? {layout: r[:layout]} : {})
		else
			render inline: r[:render_text]
		end
	end

	def post
		if params[:draft_id].present?
			draft_render
		else
			render_post(@post || params[:slug].to_s.split("/").last, true)
		end
	end

	def post_archive_router
		date = Date.parse("#{params[:date]}/01")
		year = date.strftime("%Y")
		month = date.strftime("%m")
		if params[:date]
			redirect_to :action => "post_archive_month", :year => year, :month => month
		end
	end

	def post_archive
		begin
			date = Date.parse("#{params[:year]}/#{params[:month]}/#{params[:day]}")
			@posts = CamaleonCms::Note.published.where("created_at::date = ?", date)
			if @posts.empty?
				return page_not_found
			end
		rescue
			return page_not_found
		end
		@posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page)
	end

	def post_archive_year
		begin
			@posts = CamaleonCms::Note.published.where('extract(year from created_at) = ?', params[:year])
			if @posts.empty?
				return page_not_found
			end
		rescue
			return page_not_found
		end
		@posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page)
	end

	def post_archive_month
		begin
			date = Date.parse("#{params[:year]}/#{params[:month]}")
			@posts = CamaleonCms::Note.published.where('extract(year from created_at) = ? AND extract(month from created_at) = ?', params[:year], params[:month]).order('created_at ASC')
			if @posts.empty?
				return page_not_found
			end
		rescue
			return page_not_found
		end
		@posts = @posts.paginate(:page => params[:page], :per_page => current_site.front_per_page)
	end

	def profile
		begin
			@user = current_site.users.find(params[:user_id]).decorate
		rescue
			return page_not_found
		end
		@object = @user
		@cama_visited_profile = true
		layout_ = lookup_context.template_exists?("layouts/profile") ? "profile" : nil
		r = {user: @user, layout: layout_, render: "profile"};  hooks_run("on_render_profile", r)
		render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
	end

	def render_page_not_found
		page_not_found
	end

	private
	def draft_render
		post_draft = current_site.posts.drafts.find(params[:draft_id])
		@object = post_draft

		args = { permitted: false }
		hooks_run("on_render_draft_permitted", args)

		if args[:permitted] || can?(:update, post_draft)
			render_post(post_draft, false, nil, true)
		else
			page_not_found
		end
	end

	def render_post(post_or_slug_or_id, from_url = false, status = nil, force_visit = false)
		if post_or_slug_or_id.is_a?(String)
			@post = current_site.the_posts.find_by_slug(post_or_slug_or_id) || current_site.notes.find_by_slug(post_or_slug_or_id)
		elsif post_or_slug_or_id.is_a?(Integer)
			@post = current_site.the_posts.where(id: post_or_slug_or_id).first
		else
			@post = post_or_slug_or_id
		end		

		if @post.class.name != "CamaleonCms::Note"
			@post = @post.try(:decorate)
			if !@post.present? || !(force_visit || @post.can_visit?)
				if params[:format] == 'html' || !params[:format].present?
					page_not_found()
				else
					head 404
				end
			else
				@object = @post
				@cama_visited_post = @post
				@post_type = @post.the_post_type
				@comments = @post.the_comments
				@categories = @post.the_categories
				#@post.increment_visits!

				home_page = @_site_options[:home_page] rescue nil
				if lookup_context.template_exists?("page_#{@post.id}")
					r_file = "page_#{@post.id}"
				elsif @post.get_template(@post_type).present? && lookup_context.template_exists?(@post.get_template(@post_type))
					r_file = @post.get_template(@post_type)
				elsif home_page.present? && @post.id.to_s == home_page
					r_file = "index"
				elsif lookup_context.template_exists?("post_types/#{@post_type.the_slug}/single")
					r_file = "post_types/#{@post_type.the_slug}/single"
				elsif lookup_context.template_exists?("#{@post_type.slug}")
					r_file = "#{@post_type.slug}"
				else
					r_file = "single"
				end

				layout_ = nil
				meta_layout = @post.get_layout(@post_type)
				layout_ = meta_layout if meta_layout.present? && lookup_context.template_exists?("layouts/#{meta_layout}")
				r = {post: @post, post_type: @post_type, layout: layout_, render: r_file}
				hooks_run("on_render_post", r) if from_url

				if status.present?
					render r[:render], (!r[:layout].nil? ? {layout: r[:layout], status: status} : {status: status})  
				else
					render r[:render], (!r[:layout].nil? ? {layout: r[:layout]} : {})
				end
			end
		else
			redirect_to cama_post_item_path(@post)
		end
	end

	def page_not_found()
		if @_site_options[:error_404].present?
			page_404 = current_site.posts.find(@_site_options[:error_404]) rescue ""
			if page_404.present?
				render_post(page_404, false, :not_found)
				return
			end
		end
		render_error(404)
	end

	def init_frontent
		if cama_sign_in? && params[:ccc_theme_preview].present? && can?(:manage, :themes)
			@_current_theme = (current_site.themes.where(slug: params[:ccc_theme_preview]).first_or_create!.decorate)
		end

		@_site_options = current_site.options
		session[:cama_current_language] = params[:cama_set_language].to_sym if params[:cama_set_language].present?
		session[:cama_current_language] = nil if current_site.get_languages.exclude?(session[:cama_current_language])
		I18n.locale = params[:locale] || session[:cama_current_language] || current_site.get_languages.first
		return page_not_found unless current_site.get_languages.include?(I18n.locale.to_sym)

		lookup_context.prefixes.delete("frontend")
		lookup_context.prefixes.delete("application")
		lookup_context.prefixes.delete("camaleon_cms/frontend")
		lookup_context.prefixes.delete("camaleon_cms/camaleon")
		lookup_context.prefixes.delete("camaleon_cms/apps/plugins_front")
		lookup_context.prefixes.delete("camaleon_cms/apps/themes_front")
		lookup_context.prefixes.delete_if{|t| t =~ /themes\/(.*)\/views/i || t == "camaleon_cms/default_theme" || t == "themes/#{current_site.id}/views" }

		lookup_context.prefixes.append("themes/#{current_site.id}/views") if Dir.exist?(Rails.root.join('app', 'apps', 'themes', current_site.id.to_s).to_s)
		lookup_context.prefixes.append("themes/#{current_site.get_theme_slug}/views")
		lookup_context.prefixes.append("camaleon_cms/default_theme")

		lookup_context.prefixes = lookup_context.prefixes.uniq
		lookup_context.use_camaleon_partial_prefixes = true
		theme_init()
	end

	def before_hooks
		hooks_run("front_before_load")
	end

	def after_hooks
		hooks_run("front_after_load")
	end

	def default_url_options(options = {})
		begin
			if current_site.get_languages.first.to_s == I18n.locale.to_s
				options
			else
				{ locale: I18n.locale }.merge options
			end
		rescue
			options
		end
	end
end
