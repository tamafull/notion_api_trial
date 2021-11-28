module Notion
  class Base
    require 'http'
    require 'dotenv'
    Dotenv.load

    BASE_URL = 'https://api.notion.com/'
    SEARCH_PATH = 'v1/search'

    private

    def get_api_url(*path)
      BASE_URL + path.join('/')
    end

    def convert_for_url(response_id)
      response_id.delete('-')
    end
  end
end
