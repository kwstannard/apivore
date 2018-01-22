require 'json-schema'
require 'rspec'
require 'apivore/rspec_matchers'
require 'apivore/rspec_helpers'
require 'apivore/swagger_checker'
require 'apivore/swagger'

RSpec.configure do |config|
  config.include(Apivore::RspecMatchers, type: :request)
  config.include(Apivore::RspecHelpers, type: :request)
end

# Load and register a local copy of the draft04 JSON schema to prevent network calls when resolving $refs from the swagger 2.0 schema
draft04 = JSON.parse(File.read(File.expand_path("../../data/draft04_schema.json", __FILE__)))
draft04_schema = JSON::Schema.new(draft04, Addressable::URI.parse('http://json-schema.org/draft-04/schema#'))
JSON::Validator.add_schema(draft04_schema)

module Apivore
  @loaded_checkers_by_path = {}
  @loaded_checkers_by_route = {}

  def self.from_file(path)
    @loaded_checkers_by_path[path] ||=
      SwaggerChecker.new(Apivore::Swagger.new(YAML.load_file(path)))
  end

  def self.from_route(route)
    # @loaded_files_by_path[path] ||=
    # SwaggerChecker.new(Apivore::Swagger.new(YAML.load_file(path)))
  end
end
