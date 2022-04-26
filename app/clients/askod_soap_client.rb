module Clients
  class AskodSOAPClient
    require 'savon'

    def initialize
      @@public_logger ||= Logger.new("#{Rails.root}/log/public_info.log")
      wsdl_endpoint = 'https://askod.rada-uzhgorod.gov.ua/askod/Services/ExternalFunctionService.asmx?wsdl'
      @client = Savon.client(wsdl: wsdl_endpoint)
    end

    # wrapper around the client's call method with blackjack and logging
    def call(operation, message)
      @client.call(operation, message: message).body["#{operation}_response".to_sym]["#{operation}_result".to_sym]
    rescue StandardError => e
      @@public_logger.error(e.message)
      false
    end

    # Returns a list of dates when files were uploaded.
    # @param [Date] date
    # @return [Boolean|JSON]
    def get_list_of_dates(date)
      # response = call(:get_list_dates, { year: date.year, month: date.month })
      response = call(:get_list_dates, { year: date.year, month: date.month })
      JSON.parse(response) if response
    end

    # Returns the document cards for a given date
    # @param [Date] date
    # @return [Boolean|JSON]
    def get_list_of_cards(date)
      response = call(:get_list_card, { lang: 0, date: date })
      JSON.parse(response) if response
    end

    # Returns a Ruby scalar (JSON) with file information
    # @param [Integer] card_counter
    def get_file_info_from_card(card_counter)
      response = call(:get_list_ecd_for_card, { cardCounter: card_counter.to_i })
      JSON.parse(response) if response # TODO test for multiple attachements
    end

    # Retrieves the base64 encoded string by the file counter (id).
    def get_file_binary_data(file_counter)
      response = @client.call(:get_public_ecd, message: { counter: file_counter })
      Base64.decode64(response.body[:get_public_ecd_response][:get_public_ecd_result])
    end
  end
end