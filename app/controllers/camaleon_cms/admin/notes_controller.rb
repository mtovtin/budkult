class CamaleonCms::Admin::NotesController < CamaleonCms::AdminController
	before_action :set_note, only: ['show','edit','update','destroy']
	
	def index
		@notes = current_site.notes.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@notes = @notes.where("LOWER(#{CamaleonCms::Note.table_name}.title) LIKE ?", "%#{params[:q]}%")  
		end
		if params[:date].present?
			params[:date] = Date.parse(params[:date])
			year = params[:date].strftime("%Y")
			month =  params[:date].strftime("%m")
			day =  params[:date].strftime("%d")
			@notes = @notes.where('extract(year from created_at) = ? and extract(month from created_at) = ? and extract(day from created_at) = ?', year, month, day)
		end
		if params[:tag]
			@notes.tagged_with(params[:tag])
		end
	end

	def show
	end

	def new
		@note = CamaleonCms::Note.new
		render "form"
	end

	def create
		@note = CamaleonCms::Note.new(note_params)
		@note.user = current_user

		if @note.save
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
		if @note.update(note_params)
			flash[:notice] = "Оновлено"
			redirect_to action: :edit, id: @note.id
		else
			edit
		end
	end

	def destroy
		flash[:notice] = "Видалено" if @note.destroy
		redirect_to action: :index
	end

	def recent_tags
		#ts = CamaleonCms::Note.order("created_at desc").first(100)
		#t_list = CamaleonCms::NoteTag.select("rdauzh_note_tags.*, COUNT(rdauzh_note_taggings.id) AS count").joins(:note_taggings).group("rdauzh_note_tags.id").order("count DESC")
		#t_list = []
		#@tags_list = t_list.pluck("name")
		
		@tags_list = CamaleonCms::NoteTag.select("rdauzh_note_tags.*, COUNT(rdauzh_note_taggings.id) AS t_count").joins(:note_taggings).group("rdauzh_note_tags.id").order("t_count DESC").first(30).pluck("name")
		render json: @tags_list
	end

	def note_cat_list
		@note_cats = CamaleonCms::NoteCategory.all.pluck("name")
		render json: @note_cats
	end

	def note_tag_list
		@note_tags = CamaleonCms::NoteTag.all.pluck("name")
		render json: @note_tags
	end

	def tax_category_notes
		cat = CamaleonCms::NoteCategory.find(params[:id])
		@notes = CamaleonCms::Note.catted_with(cat.slug).paginate(:page => params[:page], :per_page => current_site.admin_per_page)
		render "index"
	end

	def tax_tag_notes
		tag = CamaleonCms::NoteTag.find(params[:id])
		@notes = CamaleonCms::Note.tagged_with(tag.slug).paginate(:page => params[:page], :per_page => current_site.admin_per_page)
		render "index"
	end

	def note_categories
		@note_cats = CamaleonCms::NoteCategory.all.paginate(:page => params[:page], :per_page => 30)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@note_cats = @note_cats.where("LOWER(#{CamaleonCms::NoteCategory.table_name}.name) LIKE ?", "%#{params[:q]}%")
		end
	end

	def note_tags
		@note_tags = CamaleonCms::NoteTag.all.paginate(:page => params[:page], :per_page => 30)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@note_tags = @note_tags.where("LOWER(#{CamaleonCms::NoteTag.table_name}.name) LIKE ?", "%#{params[:q]}%")
		end
	end

	private
	def note_params
		params.require(:note).permit(:note_id, :title, :content, :tag_list, :cat_list, :site_id, :post_imported_thumb, :created_at, :status, :hide_title, :hide_thumb, :show_updated, :slider_images)
	end

	def set_note
		@note = current_site.notes.find(params[:id])
	end
end