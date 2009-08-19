# Learn more at http://github.com/datamapper/dm-more/tree/master/dm-sweatshop
require 'dm-sweatshop'
# Learn more at http://github.com/datamapper/dm-more/tree/master/dm-types
require 'dm-types'
require 'dm-aggregates'
require 'dm-validations'
require 'dm-is-paginated'

Dir['spec/fixtures/**/*_fixture.rb'].sort.each do |fixture_file|
  require fixture_file
end
