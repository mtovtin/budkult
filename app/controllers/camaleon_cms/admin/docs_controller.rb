class CamaleonCms::Admin::DocsController < CamaleonCms::AdminController
	before_action :set_doc, only: ['show','edit','update','destroy']
	def index
		#authorize! :docs, @post_type
		@docs = current_site.docs.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@docs = @docs.where("LOWER(#{CamaleonCms::Doc.table_name}.title) LIKE ?", "%#{params[:q]}%")
		end
		if params[:date].present?
			params[:date] = Date.parse(params[:date])
			year = params[:date].strftime("%Y")
			month =  params[:date].strftime("%m")
			day =  params[:date].strftime("%d")
			@docs = @docs.where('extract(year from created_at) = ? and extract(month from created_at) = ? and extract(day from created_at) = ?', year, month, day)
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

	private
	def doc_params
		params.require(:doc).permit(:doc_id, :title, :content, :tag_list, :special_type, :cat_list, :site_id, :rada_docs_url, :created_at, :status, :doc_type, :mce_session_number, :mce_forum_number, :mce_text, :mce_date, :mce_doc_number, :show_updated)
	end

	def set_doc
		@doc = current_site.docs.find(params[:id])
	end
end