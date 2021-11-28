module Notion
  class Base
    require 'http'
    require 'dotenv'
    Dotenv.load

    BASE_URL = 'https://api.notion.com/'
    SEARCH_PATH = 'v1/search'

    attr_reader :id
    attr_reader :metadata

    def initialize(id=nil, metadata={})
      @id = id
      @metadata = metadata
    end

    def search(query, object)
      url = get_api_url(SEARCH_PATH)

      response =
        HTTP[
          'Authorization': "Bearer #{ENV['NOTION_KEY']}",
          'Content-Type': 'application/json',
          'Notion-Version': ENV['NOTION_VERSION']
        ].post(url, json: {
          query: query,
          # TODO: filterでやりたい
          sort:{
            direction: 'ascending',
            timestamp: 'last_edited_time'
          }
        })
      response_json = HTTP::MimeType::JSON.decode(response)

      @metadata = response_json['results'].find {|result| result['object'] == object}
      @id = convert_for_url(@metadata['id'])

      self
    end

    private

    def get_api_url(*path)
      BASE_URL + path.join('/')
    end

    def convert_for_url(response_id)
      response_id.delete('-')
    end
  end
end
