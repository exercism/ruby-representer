source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'json'
gem 'mandate'
gem 'rake'

gem 'parser'
gem 'rubocop', '< 1.50.0'
gem 'rubocop-minitest'
gem 'rubocop-performance'

group :test do
  gem 'minitest', '~> 5.10', '!= 5.10.2'
  gem 'minitest-stub-const'
  gem 'mocha'
  gem 'pry'
  gem 'simplecov', '~> 0.17.0'
end
