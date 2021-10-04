class CamaleonCms::Admin::PetitionsController < CamaleonCms::AdminController
	before_action :set_pet, only: ['show','edit','update','destroy']
	def index
		@docs = current_site.petitions.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
	end

	def show
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

	private
	def doc_params
		params.require(:doc).permit(:author, :voters, :content, :site_id, :answer)
	end

	def set_pet
		@doc = current_site.petitions.find(params[:id])
	end
end