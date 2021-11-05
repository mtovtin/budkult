# frozen_string_literal: true

class AskodService
  require 'askod_soap_client'

  def initialize
    @client = Clients::AskodSOAPClient.new
  end

  # gets all the document cards one-by-one and returns a list
  def get_cards(date)
    valid_cards = []

    # gets all the dates on which document cards were created
    list_of_dates = @client.get_list_of_dates(date)

    # in case of an empty array or other non array value
    return [] unless list_of_dates.is_a?(Enumerable) && list_of_dates.any?

    list_of_dates.each do |date|
      # get all document cards for a given date
      document_cards = @client.get_list_of_cards(date)
      # skip if empty card
      next if [0, -1].include?(document_cards)

      document_cards.each do |card|
        # add a placeholder for file info
        card['file_info'] = nil
        # replace empty values with dashes and add some flags
        card = prepare_card_values(card)
        valid_cards << card
      end
    end
    valid_cards.sort_by { |card| card['RegDate'] }
  end

  # loops over each document's key-value pairs and replaces empty values with dashes
  # and adds 'personal data' flag based on 'DraftDecisions' attribute's value
  def prepare_card_values(document_card)
    document_card.each do |key_value_pair|
      key = key_value_pair[0]
      val = key_value_pair[1]
      document_card[key] = '-' unless val.present?
      document_card[key] = 'Інші питання' if key == 'Branch' && !val.present?
      document_card[key] = 'personal_data' if key == 'DraftDecisions' && val == '5623'
    end
    document_card
  end

  # returns a list of document cards selected by date
  def select_documents_by_date(date, import_mode = 'day')
    # input date should be a Date instance
    date_str = date.strftime('%d.%m.%Y 0:0:0')
    # get_cards method needs a Date instance, but select needs a date string to compare with value
    cards = get_cards(date)
    # filter cards by date
    if import_mode == 'day'
      cards = cards.select { |card| card['RegDate'] == date_str }
    end
    cards = add_file_info(cards) # TODO: figure out how to optimize with full month
  end

  # retrieve and add file-info to a narrowed down list of documents to
  # speed up the process
  def add_file_info(cards)
    cards.each do |card|
      if card['DraftDecisions'] != 'personal_data'
        card['file_info'] = @client.get_file_info_from_card(card['Counter'])
        if !card['file_info'].is_a?(Enumerable) || !card['file_info'].any?
          # TODO refactor - just a crutch to avoid errors down the line
          card['file_info'] = [[]]
        end
      end
    end
  end

  # batch-creates documents from document-cards that were retrieved via askod-api
  def create_db_records_from_document_cards(date, user_id = '', import_mode = 'day', doc_status_published = false, filter_by_doc_kind = false, doc_category_names = nil)
    if doc_category_names.present?
      category_ids = retrieve_category_ids(doc_category_names)
    end
    document_cards = select_documents_by_date(date, import_mode)
    # filter by kind
    if filter_by_doc_kind.present?
      document_cards = document_cards.select { |card| card['Kind'] == filter_by_doc_kind }
    end

    list_of_document_attributes = prepare_attributes(document_cards, user_id, doc_status_published)
    # creates documents from provided attributes
    creation_result = CamaleonCms::Doc.create(list_of_document_attributes)
    # get the ids of newly created documents
    created_doc_ids = creation_result.map(&:id).reject { |x| x.nil? }
    # in case we have both doc ids and categories
    if created_doc_ids.present? && category_ids.present?
      attrs = prepare_category_doc_relation(created_doc_ids, category_ids)
      # assigns docs to categories
      CamaleonCms::Categorization.create(attrs)
    end
    creation_result
  end

  def retrieve_category_ids(category_names)
    category_ids = []
    # make an array, map through and strip ends, remove empty values from array
    names_array = category_names.split(",").map(&:strip).reject!(&:empty?)
    names_array.each { |name|
      category_record = CamaleonCms::DocCategory.find_by(name: name)
      if category_record.present?
        # if category id not already in 'category_ids' array, add it to it
        if category_ids.exclude?(category_record.id)
          category_ids.push(category_record.id)
        end
      end
    }
    category_ids
  end

  def prepare_category_doc_relation(document_ids, category_ids)
    attributes = []
    document_ids.each do |doc_id|
      category_ids.each do |cat_id|
        doc_category_rel = {
          'doc_id' => doc_id,
          'doc_category_id' => cat_id,
        }
        attributes << doc_category_rel
      end
    end
    attributes
  end

  # prepare attributes before saving to db
  def prepare_attributes(document_cards, user_id, doc_status_published)
    list_of_document_attributes = []
    document_cards.each do |card|
      doc_attributes = {
        'title' => prepare_title(card),
        'content' => card['Content'],
        'site_id' => 1,
        'created_at' => card['RegDate'],
        'status' => !doc_status_published ? 'draft' : 'published',
        'mce_doc_number' => card['DocIndex'].to_i,
        'show_updated' => '0',
        'user_id' => user_id,
        'counter' => card['Counter'],
        'doc_index' => card['DocIndex'],
        'full_index' => card['FullIndex'],
        'source_folder' => card['SourceFolder'],
        'receipt_date' => card['ReceiptDate'],
        'source' => card['Source'],
        'branch' => card['Branch'],
        'ground' => card['Ground'],
        'doc_stamp' => card['DraftDecisions'],
        'keywords' => card['KeyWords'],
        'file_type' => card['DocType'],
        'kind' => card['Kind'],
        'file_counter' => card['file_info'][0].present? ? card['file_info'][0]['Counter'] : nil,
        'file_name' => card['file_info'][0].present? ? card['file_info'][0]['FileName'] : nil
      }
      list_of_document_attributes << doc_attributes
    end
    list_of_document_attributes
  end

  # removes multiple whitespaces (\t\r\n) in between words and strip them at the ends
  # capitalizes text if it's in all-CAPS
  def normalize_text(text)
    text = text.gsub(/\s+/, ' ').strip
    # dont touch text that not in ALL CAPS
    return text if text != text.upcase

    text.capitalize
  end

  def prepare_title(card)
    doc_date = begin
      card['RegDate'].to_time.strftime('%d.%m.%Y')
    rescue StandardError
      ''
    end
    doc_idx = begin
      "№#{card['DocIndex'].to_i}"
    rescue StandardError
      ''
    end
    # change document title depending on its 'kind'
    if card['Kind'].start_with?('Проєкт рішення', 'Проект рішення')
      "#{normalize_text(card['Content'].to_s)}"
    else
      "#{card['Kind']} #{doc_idx} від #{doc_date} #{normalize_text(card['Content'].to_s)}"
    end
  end

  def get_binary_data_of_the_file(file_counter)
    @client.get_file_binary_data(file_counter)
  end

  # TODO: refactor and test
  def write_file(file_name, file_binary)
    File.open(Rails.root.join('public/documents', file_name), 'wb') do |f|
      f.write(Base64.decode64(file_binary))
    end
  end
end
