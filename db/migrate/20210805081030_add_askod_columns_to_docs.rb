class AddAskodColumnsToDocs < ActiveRecord::Migration[5.2]
  def change
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :counter, :integer
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :doc_index, :integer
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :full_index, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :source_folder, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :receipt_date, :datetime
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :source, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :branch, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :ground, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :keywords, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :file_type, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :kind, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :file_counter, :integer
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :file_name, :string
    add_column :"#{PluginRoutes.static_system_info['db_prefix']}docs", :doc_stamp, :string
    add_index :"#{PluginRoutes.static_system_info['db_prefix']}docs", :counter, unique: true, where: 'counter IS NOT NULL'
    add_index :"#{PluginRoutes.static_system_info['db_prefix']}docs", :doc_index, unique: false, where: 'doc_index IS NOT NULL'
    add_index :"#{PluginRoutes.static_system_info['db_prefix']}docs", :mce_doc_number, unique: false, where: 'mce_doc_number IS NOT NULL'
    add_index :"#{PluginRoutes.static_system_info['db_prefix']}docs", :kind, unique: false, where: 'kind IS NOT NULL'
    add_index :"#{PluginRoutes.static_system_info['db_prefix']}docs", :branch, unique: false, where: 'branch IS NOT NULL'
    add_index :"#{PluginRoutes.static_system_info['db_prefix']}docs", :source, unique: false, where: 'source IS NOT NULL'
    # add_index :"#{PluginRoutes.static_system_info['db_prefix']}docs", [:doc_index, :mce_doc_number, :kind, :branch, :source], unique: false, where: 'doc_index IS NOT NULL AND mce_doc_number IS NOT NULL AND kind IS NOT NULL AND branch IS NOT NULL AND source IS NOT NULL', name: 'index_docs_doc_num_kind_branch_source'
  end
end
