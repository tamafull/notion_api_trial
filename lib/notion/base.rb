module Notion
  class Base
    require 'http'
    require 'dotenv'
    Dotenv.load

    BASE_URL = 'https://api.notion.com/'
    SEARCH_PATH = 'v1/search'

    class << self
      private

      def get_api_url(*path)
        BASE_URL + path.join('/')
      end
    end
  end
end
