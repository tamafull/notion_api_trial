$LOAD_PATH.push('./lib')
require 'notion'

if ARGV[0] == 'db' && !ARGV[1].nil?
  response = Notion::Database.get(ARGV[1])
end

if ARGV[0] == 'search' && !ARGV[1].nil?
  response = Notion::Database.search(ARGV[1])
end

p response
