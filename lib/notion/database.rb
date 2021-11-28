require 'notion/base'

module Notion
  class Database < Notion::Base
    DATABASE_API_PATH = 'v1/databases'

    attr_reader :id
    attr_reader :metadata

    def initialize(id=nil, metadata={})
      @id = id
      @metadata = metadata
    end

    def self.search(query) # TODO: タイトル以外で検索できない？
      instance = new
      instance.search(query)

      instance
    end

    def search(query)
      url = get_api_url(SEARCH_PATH)

      response =
        HTTP[
          'Authorization': "Bearer #{ENV['NOTION_KEY']}",
          'Content-Type': 'application/json',
          'Notion-Version': ENV['NOTION_VERSION']
        ].post(url, json: {
          query: query,
          # filter:{
          #   value: 'database'
          # }, # TODO: 使い方がわからず取れない。できればselectせずに取得する段階でfilterをかけたい。
          sort:{
            direction: 'ascending',
            timestamp: 'last_edited_time'
          }
        })
      response_json = HTTP::MimeType::JSON.decode(response)

      @metadata = response_json['results'].find {|result| result['object'] == 'database'} # TODO: page用も必要なのでどこかに切り出す
      @id = convert_for_url(@metadata['id'])
    end

    # NOTE: https://developers.notion.com/reference/retrieve-a-database
    def self.get(id)
      url = get_api_url(DATABASE_API_PATH, id)

      HTTP::MimeType::JSON.decode(HTTP[
        'Authorization': "Bearer #{ENV['NOTION_KEY']}",
        'Notion-Version': ENV['NOTION_VERSION']
      ].get(url))
    end
  end
end
