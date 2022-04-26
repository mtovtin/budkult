Rails.application.config.to_prepare do
  CamaleonCms::UploaderHelper.class_eval do

    # overriding the upload_file method, just to prepend a time prefix to filename. (e.g.: 14-03-48_test.jpg)
    # changes were made on line 20 and 27. (filename_time_prefix)
    def upload_file(uploaded_io, settings = {})
      cached_name = uploaded_io.is_a?(ActionDispatch::Http::UploadedFile) ? uploaded_io.original_filename : nil
      return { error: "File is empty", file: nil, size: nil } unless uploaded_io.present?
      if uploaded_io.is_a?(String) && uploaded_io.match(/^https?:\/\//).present? # download url file
        tmp = cama_tmp_upload(uploaded_io)
        return tmp if tmp[:error].present?
        settings[:remove_source] = true
        uploaded_io = tmp[:file_path]
      end
      uploaded_io = File.open(uploaded_io) if uploaded_io.is_a?(String)
      uploaded_io = File.open(cama_resize_upload(uploaded_io.path, settings[:dimension])) if settings[:dimension].present? # resize file into specific dimensions

      settings = settings.to_sym
      settings[:uploaded_io] = uploaded_io
      filename_time_prefix = Time.now.strftime('%H-%M-%S_')
      settings = {
        folder: "",
        maximum: current_site.get_option('filesystem_max_size', 100).to_f.megabytes,
        formats: "*",
        generate_thumb: true,
        temporal_time: 0,
        filename: (filename_time_prefix + (cached_name || uploaded_io.original_filename) rescue uploaded_io.path.split("/").last).cama_fix_filename,
        file_size: File.size(uploaded_io.to_io),
        remove_source: false,
        same_name: false,
        versions: '198x128,300x186',
        thumb_size: nil
      }.merge(settings)
      hooks_run("before_upload", settings)
      res = { error: nil }

      # formats validations
      return { error: "#{ct("file_format_error")} (#{settings[:formats]})" } unless cama_uploader.class.validate_file_format(uploaded_io.path, settings[:formats])

      # file size validations
      if settings[:maximum] < settings[:file_size]
        res[:error] = "#{ct("file_size_exceeded", default: "File size exceeded")} (#{number_to_human_size(settings[:maximum])})"
        return res
      end
      # save file
      key = File.join(settings[:folder], settings[:filename]).to_s.cama_fix_slash
      res = cama_uploader.add_file(settings[:uploaded_io], key, { same_name: settings[:same_name] })
      {} if settings[:temporal_time] > 0 # temporal file upload (always put as local for temporal files) (TODO: use delayjob)

      # generate image versions
      if res['file_type'] == 'image'
        settings[:versions].to_s.gsub(' ', '').split(',').each do |v|
          version_path = cama_resize_upload(settings[:uploaded_io].path, v, { replace: false })
          cama_uploader.add_file(version_path, cama_uploader.version_path(res['key'], v), is_thumb: true, same_name: true)
          FileUtils.rm_f(version_path)
        end
      end

      # generate thumb
      cama_uploader_generate_thumbnail(uploaded_io.path, res['key'], settings[:thumb_size], settings[:remove_source]) if settings[:generate_thumb] && res['thumb'].present?
      FileUtils.rm_f(uploaded_io.path) if File.exist?(uploaded_io.path) if settings[:remove_source]

      hooks_run('after_upload', settings)
      res
    end
  end
end
