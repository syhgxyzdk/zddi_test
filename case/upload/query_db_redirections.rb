require 'sqlite3'
redirect_db = '/usr/local/zddi/redirect.db'
r = ""
db = SQLite3::Database.new(redirect_db)
query_redirections_url = "Select * From 'redirection'"
db.execute(query_redirections_url) do |row|
    r << row.to_s
end
db.close
puts r
