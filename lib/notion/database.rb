require 'notion/base'

module Notion
  class Database < Notion::Base
    DATABASE_API_PATH = 'v1/databases'

    def initialize()
      @id = nil
    end

    # NOTE: https://developers.notion.com/reference/post-search
    def self.search(query) # TODO: タイトル以外で検索できない？
      url = BASE_URL + SEARCH_PATH

      response =
        HTTP[
          'Authorization': "Bearer #{ENV['NOTION_KEY']}",
          'Content-Type': 'application/json',
          'Notion-Version': ENV['NOTION_VERSION']
        ].post(url, json: {
          query: query,
          sort:{
            direction: 'ascending',
            timestamp: 'last_edited_time'
          }
        })
      response_json = HTTP::MimeType::JSON.decode(response)

      response_json['results'].select {|result| result['object'] == 'database'} # TODO: page用も必要なのでどこかに切り出す
    end

    # NOTE: https://developers.notion.com/reference/retrieve-a-database
    def self.get(id)
      HTTP::MimeType::JSON.decode(HTTP[
        'Authorization': "Bearer #{ENV['NOTION_KEY']}",
        'Notion-Version': ENV['NOTION_VERSION']
      ].get(BASE_URL + DATABASE_API_PATH +  '/' + id))
    end
  end
end
