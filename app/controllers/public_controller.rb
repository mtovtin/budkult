class PublicController < CamaleonCms::FrontendController
  before_action :set_parameters
  #protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  def index
    require 'will_paginate/array'
    @docs = current_site.docs
    # options for document selectors
    @document_kinds = @docs.published.group(:kind).pluck(:kind).reject(&:nil?)
    @document_branches = @docs.published.group(:branch).pluck(:branch).reject(&:nil?)
    @document_sources = @docs.published.group(:source).pluck(:source).reject(&:nil?)
    @docs = @docs.published.paginate(page: params[:page], per_page: current_site.front_per_page)
    render template: 'public/search'
  end

  def feed
    @title = current_site.the_title.sub! 'сайт', 'RSS'
  
    @notes = CamaleonCms::Note
              .catted_with('ukrnet')
              .published
              .select(:id, :title, :slug, :created_at, :updated_at, :content, :post_imported_thumb)
              .order("created_at desc")
              .paginate(:page => params[:page], :per_page => 50)
  
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  # filter method that's being called by ajax when changing filters on '/documents' page
  def filter
    require 'will_paginate/array'
    @docs = current_site.docs

    # filter by date range
    if params[:date_filter].present?
      start_date, end_date = params[:date_filter].split(' - ')
      # 'beginning_of_day' and 'end_of_day trick to cover the whole day
      # in case the same day is selected both for start and end date
      start_date, end_date = helpers.get_date_range(start_date, end_date)
      @docs = @docs.by_doc_created_at_between(start_date, end_date)
    end

    # filter by title
    @docs = @docs.by_title(params[:search_term].strip.downcase) if params[:search_term].strip.present?
    # filter by doc number
    @docs = @docs.by_doc_number(params[:doc_number].to_i.to_s) if params[:doc_number].present?
    # filter by doc document kind
    @docs = @docs.by_doc_kind(params['kind']) if params['kind'].present?
    # filter by doc document branch
    @docs = @docs.by_doc_branch(params['branch']) if params['branch'].present?
    # filter by doc document source
    @docs = @docs.by_doc_source(params['source']) if params['source'].present?
    # show only published
    @docs = @docs.published
    # select only the necessary columns (pluck breaks pagination)
    @docs = @docs.select(:title, :doc_index, :mce_doc_number, :kind, :created_at, :slug, :rada_docs_url, :doc_stamp)
    # add pagination
    @docs = @docs.paginate(page: params[:page], per_page: current_site.front_per_page)
    render partial: 'public/partials/document_search_grid', locals: { items: @docs }
  end

  # Sends data straight to the client (browser) for downloading or rendering.
  # (Instead of saving binary to file and than sending the file)
  # @param [String] file_name
  # @param [Base64] file_binary
  def send_binary_data_to_browser(file_name, file_binary)
    file_extension = file_name.split('.').last.downcase
    doc_type = case file_extension
               when 'pdf' then 'application/pdf'
               when 'doc' then 'application/msword'
               when 'docx' then 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
               when 'odt' then 'application/vnd.oasis.opendocument.text'
               when 'jpg' then 'image/jpeg'
               when 'png' then 'image/png'
               when 'tiff' then 'image/tiff'
               when 'rtf' then 'application/rtf'
               else 'application/octet-stream'
               end
    send_data(file_binary, filename: file_name, type: doc_type, disposition: 'inline')
  end

  # find the document by its title and get the file_id and the file_name
  # make a call to the api-service to retrieve the binary data
  def download
    file_id, file_name = CamaleonCms::Doc.where(slug: params[:title]).pluck(:file_counter, :file_name).first
    # missing attributes
    if !file_id.present? || !file_name.present?
      public_logger.error("#{request.referer} - File not found")
      return redirect_back fallback_location: documents_path, notice: 'File not found'
    end
    file_binary = @service.get_binary_data_of_the_file(file_id)
    # missing file binary
    unless file_binary.present?
      public_logger.error("filename: #{file_name}, file id: #{file_id} - file binary missing")
      return redirect_back fallback_location: documents_path
    end
    send_binary_data_to_browser(file_name, file_binary)
  end

  # service is set up on request
  def set_parameters
    @service ||= AskodService.new
  end

  # custom logger
  def public_logger
    @@public_logger ||= Logger.new("#{Rails.root}/log/public_documents.log")
  end
end
