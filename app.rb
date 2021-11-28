module Notion
  require 'http'
  require 'dotenv'
  Dotenv.load

  BASE_URL = 'https://api.notion.com/'
  SEARCH_PATH = 'v1/search'

  class Database
    DATABASE_API_PATH = 'v1/databases'

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
      DATABASE_URL = BASE_URL + DATABASE_API_PATH +  '/' + id

      HTTP::MimeType::JSON.decode(HTTP[
        'Authorization': "Bearer #{ENV['NOTION_KEY']}",
        'Notion-Version': ENV['NOTION_VERSION']
      ].get(DATABASE_URL))
    end
  end
end

if ARGV[0] == 'db' && !ARGV[1].nil?
  response = Notion::Database.get(ARGV[1])
end

if ARGV[0] == 'search' && !ARGV[1].nil?
  response = Notion::Database.search(ARGV[1])
end

p response
