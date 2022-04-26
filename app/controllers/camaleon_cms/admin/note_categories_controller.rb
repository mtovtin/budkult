class CamaleonCms::Admin::NoteCategoriesController < CamaleonCms::AdminController
	before_action :set_cat, only: ['show','edit','update','destroy']
	def index
		@categories = CamaleonCms::NoteCategory.all.paginate(:page => params[:page], :per_page => 30)
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@categories = @categories.where("LOWER(#{CamaleonCms::NoteCategory.table_name}.name) LIKE ?", "%#{params[:q]}%")
		end
		@category = CamaleonCms::NoteCategory.new
	end

	def show
	end

	def edit
	end

	def create
		@category = CamaleonCms::NoteCategory.new(cat_params)
		if @category.save
			flash[:notice] = "Створено"
			redirect_to action: :index
		else
			render 'edit'
		end
	end

	def update
		if @category.update(cat_params)
			flash[:notice] = "Оновлено"
			redirect_to action: :index
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
		params.require(:category).permit(:name, :is_enabled)
	end

	def set_cat
		@category = CamaleonCms::NoteCategory.find(params[:id])
	end
end