require 'notion/base'

module Notion
  class Database < Notion::Base
    DATABASE_API_PATH = 'v1/databases'

    def self.search(query) # TODO: タイトル以外で検索できない？
      instance = new
      instance.search(query)

      instance
    end

    def search(query, object='database')
      super
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
