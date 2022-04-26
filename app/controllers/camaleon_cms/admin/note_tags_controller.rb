class CamaleonCms::Admin::NoteTagsController < CamaleonCms::AdminController
	before_action :set_tag, only: ['show','edit','update','destroy']
	def index
		@categories = CamaleonCms::NoteTag.all.paginate(:page => params[:page], :per_page => 30)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@categories = @categories.where("LOWER(#{CamaleonCms::NoteTag.table_name}.name) LIKE ?", "%#{params[:q]}%")
		end
	end

	def show
	end

	def edit
	end

	def update
		if @category.update(cat_params)
			flash[:notice] = "Оновлено"
			redirect_to action: :edit, id: @category.id
		else
			edit
		end
	end

	def destroy
		flash[:notice] = "Видалено" if @category.destroy
		redirect_to action: :index
	end

	private
	def cat_params
		params.require(:category).permit(:name)
	end

	def set_tag
		@category = CamaleonCms::NoteTag.find(params[:id])
	end
end