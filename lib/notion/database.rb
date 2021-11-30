require 'notion/base'

module Notion
  class Database < Notion::Base
    DATABASE_API_PATH = 'v1/databases'
    SEARCH_API_PATH = 'v1/search'

    attr_reader :id
    attr_reader :metadata

    def initialize(id=nil, metadata={})
      @id = id&.delete('-')
      @metadata = metadata
    end

    # NOTE: https://developers.notion.com/reference/post-search
    def self.search(query)
      url = get_api_url(SEARCH_API_PATH)

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

      metadata = response_json['results'].find {|result| result['object'] == 'database'}

      new(metadata['id'], metadata) unless metadata.nil?
    end

    # NOTE: https://developers.notion.com/reference/retrieve-a-database
    def self.get(id)
      url = get_api_url(DATABASE_API_PATH, id)

      response = HTTP[
        'Authorization': "Bearer #{ENV['NOTION_KEY']}",
        'Notion-Version': ENV['NOTION_VERSION']
      ].get(url)

      response_json = HTTP::MimeType::JSON.decode(response)

      new(response_json['id'], response_json['object'])
    end
  end
end
