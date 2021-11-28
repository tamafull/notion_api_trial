module Notion
  require 'http'
  require 'dotenv'
  Dotenv.load

  BASE_URL = 'https://api.notion.com/'
  SEARCH_PATH = 'v1/search'

  class Database
    DATABASE_API_PATH = 'v1/databases'
    DATABASE_URL = BASE_URL + DATABASE_API_PATH +  '/' + ENV['NOTION_DATABASE_ID']

    # NOTE: https://developers.notion.com/reference/post-search
    def self.search(query) # TODO: タイトル以外で検索できない？
      url = BASE_URL + SEARCH_PATH

      response =
        HTTP[
          'Authorization': "Bearer #{ENV['NOTION_KEY']}",
          'Content-Type': 'application/json',
          'Notion-Version': '2021-08-16'
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
    def self.get
      HTTP::MimeType::JSON.decode(HTTP[
        'Authorization': "Bearer #{ENV['NOTION_KEY']}",
        'Notion-Version': '2021-08-16'
      ].get(DATABASE_URL))
    end
  end
end

response = Notion::Database.get if ARGV[0] == 'db'
if ARGV[0] == 'search' && !ARGV[1].nil?
  response = Notion::Database.search(ARGV[1])
end

p response
