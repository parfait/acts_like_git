ENV["RAILS_ENV"] = "test"
$:.unshift File.dirname(__FILE__) + '/../lib'

begin
  require 'rubygems'
  require 'spec'
  require 'yaml'
  require 'mocha'
  require 'active_record'
  require 'active_support'
  require 'acts_like_git'
rescue LoadError
  puts "acts_like_git requires the mocha and test-spec gems to run it's tests"
  exit
end

require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rake/gempackagetask'

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

ActiveRecord::Base.logger = Logger.new(STDOUT) if 'irb' == $0

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => ':memory:')
ActiveRecord::Migration.verbose = false

ActiveRecord::Base.silence do
  ActiveRecord::Schema.define(:version => 1) do
    with_options :force => true do |m|
      m.create_table 'posts' do |t|
        t.string  :title
        t.text    :body
        t.string  :version
        t.timestamps
      end
    end
  end
end

require File.join(File.dirname(__FILE__), '/fixtures/models')