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
    def self.search(query)
      url = BASE_URL + SEARCH_PATH

      # TODO: 多分、ここで取得したIDのハイフンを取り除いたものを指定してDB取得できる
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
    end

    # NOTE: https://developers.notion.com/reference/retrieve-a-database
    def self.get
      HTTP[
        'Authorization': "Bearer #{ENV['NOTION_KEY']}",
        'Notion-Version': '2021-08-16'
      ].get(DATABASE_URL)
    end
  end
end

response = Notion::Database.get if ARGV[0] == 'db'
response = Notion::Database.search(ARGV[1]) if ARGV[0] == 'search' && !ARGV[1].nil?

response.body.each do |r|
  p r
end