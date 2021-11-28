module Notion
  class Base
    require 'http'
    require 'dotenv'
    Dotenv.load

    BASE_URL = 'https://api.notion.com/'
    SEARCH_PATH = 'v1/search'
  end
end
