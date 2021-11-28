require 'notion/base'

module Notion
  class Page < Notion::Base
    def search(query, object='page')
      super
    end
  end
end
