class CamaleonCms::Admin::RequestsController < CamaleonCms::AdminController
  before_action :set_request, only: ['show', 'destroy']
  def index
    @requests = current_site.requests.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
  end

  def pub_request
    @form = current_site.contact_forms.find_by(slug: "dostup-do-pub-informatsii")
    values = JSON.parse(@form.value).to_sym
    @op_fields = values[:fields].select{ |field| field }
    @forms = current_site.contact_forms.where({parent_id: @form.id})
    @forms = @forms.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
    render "old"
  end

  def req_request
    @form = current_site.contact_forms.find_by(slug: "zvernen-do-uzhgorodskoi-miskoi-radi")
    values = JSON.parse(@form.value).to_sym
    @op_fields = values[:fields].select{ |field| field }
    @forms = current_site.contact_forms.where({parent_id: @form.id})
    @forms = @forms.paginate(:page => params[:page], :per_page => current_site.admin_per_page)
    render "old"
  end

  def show
  end

  def destroy
    flash[:notice] = t('camaleon_cms.admin.post_type.message.deleted') if @request.destroy
    redirect_to action: :index
  end


  private
  def set_request
    @request = current_site.requests.find(params[:id])
  end
end