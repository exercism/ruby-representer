require 'json'
require 'cgi'
require 'rubocop'
require 'parser/current'

exercise_slug = ARGV[0]
path = Pathname.new(ARGV[1])

code_to_analyze = File.read(path / "#{exercise_slug.tr('-', '_')}.rb")
analysis = JSON.parse(File.read(path / "analysis.json"))

buffer        = Parser::Source::Buffer.new(nil)
buffer.source = code_to_analyze
builder       = RuboCop::AST::Builder.new
parser        = Parser::CurrentRuby.new(builder)
ast           =  parser.parse(buffer)

representation = ast.to_s.tr("\n", " ").squeeze(" ").gsub('"', '\"')

File.open(path / "representation.sql", "w") do |f|
  f.write(%{INSERT INTO fixtures (track_slug, exercise_slug, representation, status, comments_data) VALUES ("ruby", "#{exercise_slug}", "#{representation}", '#{analysis['status']}', '#{analysis['comments'].to_json}')})
end
