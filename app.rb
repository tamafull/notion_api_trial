module Notion
  require 'http'
  require 'dotenv'
  Dotenv.load

  BASE_URL = 'https://api.notion.com/'

  class Database
    DATABASE_API_PATH = 'v1/databases/'
    DATABASE_URL = BASE_URL + DATABASE_API_PATH + ENV['NOTION_DATABASE_ID']

    def self.get
      HTTP[
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{ENV['NOTION_KEY']}",
        'Notion-Version': '2021-08-16'
      ].get(DATABASE_URL)
    end
  end
end

response = Notion::Database.get if ARGV[0] == 'db'

p response&.status
