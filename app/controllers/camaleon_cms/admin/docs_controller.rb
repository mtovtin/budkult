class CamaleonCms::Admin::DocsController < CamaleonCms::AdminController
	before_action :set_doc, only: ['show','edit','update','destroy']
	before_action :set_parameters
	protect_from_forgery with: :exception

	def index
		#authorize! :docs, @post_type
		@document_kind = current_site.docs.group(:kind).pluck(:kind).reject(&:nil?)
		@docs = current_site.docs.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@docs = @docs.where("LOWER(#{CamaleonCms::Doc.table_name}.title) LIKE ?", "%#{params[:q]}%")
		end
		if params[:date].present?
			start_date = end_date = params[:date].to_s
			start_date, end_date = helpers.get_date_range(start_date, end_date)
			@docs = @docs.having_created_at_between(start_date, end_date)
		end
		if params[:tag]
			@docs.tagged_with(params[:tag])
		end
	end

	def show
	end

	def new
		@doc = CamaleonCms::Doc.new
		render "form"
	end

	def create
		@doc = CamaleonCms::Doc.new(doc_params)
		@doc.user = current_user
		
		if @doc.save
			flash[:notice] = "Створено"
			redirect_to action: :index
		else
			new
		end
	end

	def edit
		render "form"
	end

	def update
		if @doc.update(doc_params)
			flash[:notice] = "Оновлено"
			redirect_to action: :edit, id: @doc.id
		else
			edit
		end
	end

	def destroy
		flash[:notice] = "Видалено" if @doc.destroy
		redirect_to action: :index
	end

	def doc_cat_list
		@doc_cats = CamaleonCms::DocCategory.all.not_special.pluck("name")
		render json: @doc_cats
	end

	def doc_cat_autocomplete()
		if params['autocomplete_query'].present?
			query = params['autocomplete_query'].downcase
			suggestions = CamaleonCms::DocCategory.autocomplete_search(query)
			render json: suggestions
		end
	end

	def doc_spcat
		@doc_spcats = CamaleonCms::DocCategory.all.special.pluck("name")
		render json: @doc_spcats
	end

	def doc_tag_list
		@doc_tags = CamaleonCms::DocTag.all.pluck("name")
		render json: @doc_tags
	end

	def doc_categories
		@doc_cats = CamaleonCms::DocCategory.all.paginate(:page => params[:page], :per_page => 30)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@doc_cats = @doc_cats.where("LOWER(#{CamaleonCms::DocCategory.table_name}.name) LIKE ?", "%#{params[:q]}%")
		end
	end

	def doc_tags
		@doc_tags = CamaleonCms::DocTag.all.paginate(:page => params[:page], :per_page => 30)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@doc_tags = @doc_tags.where("LOWER(#{CamaleonCms::DocTag.table_name}.name) LIKE ?", "%#{params[:q]}%")
		end
	end

	def tax_category_docs
		cat = CamaleonCms::DocCategory.find(params[:id])
		@docs = CamaleonCms::Doc.catted_with(cat.slug).paginate(:page => params[:page], :per_page => current_site.admin_per_page)
		render "index"
	end

	def tax_tag_docs
		tag = CamaleonCms::DocTag.find(params[:id])
		@docs = CamaleonCms::Doc.tagged_with(tag.slug).paginate(:page => params[:page], :per_page => current_site.admin_per_page)
		render "index"
	end

	# import document card info from 'Askod' into database
	def import
		# if toggle is on - than status is 'published'
		doc_status_published = false
		if params['adm_import'].present? && params['adm_import']['doc_published'].present?
			doc_status_published = true
		end

		# filter on document kinds
		filter_by_doc_kind = false
		if params[:kind_filter].present?
			filter_by_doc_kind = params[:kind_filter]
		end

		# category names
		if params['adm_import'].present? && params['adm_import']['doc_category'].present?
			doc_category_names = params['adm_import']['doc_category']
		end

		creation_result = @service.create_db_records_from_document_cards(@date, @user_id, @import_mode, doc_status_published, filter_by_doc_kind, doc_category_names)
		unless creation_result.is_a?(Enumerable)
			flash[:alert] = '<b>Виникла помилка - документів не було створено</b>'
			return redirect_to controller: 'camaleon_cms/admin/docs', action: :index
		end

		# select only those objects that were created (have id's)
		# created_docs = creation_result.select(&:id)
		created_docs = creation_result.select { |item| item['id'] }

		if created_docs.any?
			msg = '<b>Створені наступні документи:</b><br>'
			msg += created_docs.each_with_index.map do |obj, idx|
				"#{idx + 1} - #{obj.title}... (#{obj.full_index})"
			end.join('<br>')
			# cookie overflow mitigation
			flash[:notice] = msg.bytesize <= 2500 ? msg : "<b>Було імпортовано #{created_docs.length} документів</b>"
		else
			flash[:notice] =
				'<b>Документів не було створено. Можливо ви намагаєтесь імпортувати документи, що вже існують</b>'
		end
		redirect_to controller: 'camaleon_cms/admin/docs', action: :index
	end

	private
	def doc_params
		params.require(:doc).permit(:doc_id, :title, :content, :tag_list, :special_type, :cat_list, :site_id, :rada_docs_url, :created_at, :status, :doc_type, :mce_session_number, :mce_forum_number, :mce_text, :mce_date, :mce_doc_number, :show_updated)
	end

	def set_doc
		@doc = current_site.docs.find(params[:id])
	end



	# client, user_id and date is set up on request
	def set_parameters
		@service ||= AskodService.new
		@import_mode = get_import_mode_from_request
		@date = get_date_from_request
		@user_id = begin
								 current_user.id
							 rescue StandardError
								 nil
							 end
	end

	def get_import_mode_from_request
		if params.key?(:adm_import) && params['adm_import'].present?
			params['adm_import']['date_toggle'].present? && params['adm_import']['date_toggle'] == 'on' ? 'day' : 'month'
		end
	end

	# retrieves the date from request parameters. in case of error - returns current date
	# with basic date validation and error logging
	# left it here instead of helper, because of its specific validation (range of years between 2018-now)
	def get_date_from_request
		date = if params.key?(:date) && @import_mode != 'month'
						 params.key?(:date) && params['date'].present? ? Date.parse(params['date'], '%Y-%m-%d') : Date.today
					 else
						 params.key?(:date) && params['date'].present? ? Date.strptime(params['date'], '%Y-%m') : Date.today
					 end

		message = 'Argument error - year and month outside the specified range'
		# checking that the year is between 2018 and the current year and also that the month number is correct
		raise message unless (date.year >= 2018 && date.year <= Date.today.year) && (1..12).include?(date.month)

		date
	rescue StandardError => e
		document_logger.error(e.message)
		Date.today
	end

	# custom logger
	def document_logger
		@@document_logger ||= Logger.new("#{Rails.root}/log/document_import.log")
	end
end