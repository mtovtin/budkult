class CamaleonCms::Admin::DocCategoriesController < CamaleonCms::AdminController
	before_action :set_cat, only: ['show','edit','update','destroy']
	def index
		@categories = CamaleonCms::DocCategory.not_special.paginate(:page => params[:page], :per_page => 30)
		@spcategories = CamaleonCms::DocCategory.special
		if params[:q].present?
			params[:q] = (params[:q] || '').downcase
			@categories = @categories.where("LOWER(#{CamaleonCms::DocCategory.table_name}.name) LIKE ?", "%#{params[:q]}%")
		end
		@category = CamaleonCms::DocCategory.new
	end

	def show
	end

	def edit
	end

	def create
		@category = CamaleonCms::DocCategory.new(cat_params)
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
		params.require(:category).permit(:doc_type, :name)
	end

	def set_cat
		@category = CamaleonCms::DocCategory.find(params[:id])
	end
end