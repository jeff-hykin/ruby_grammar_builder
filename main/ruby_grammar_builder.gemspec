# frozen_string_literal: true
require "date"
require 'json'

# version bump on build
version_path = File.dirname(__FILE__)+"/version.json"
major, minor, patch = JSON.parse(IO.read(version_path))
patch+=1
IO.write(version_path, JSON.unparse([major,minor,patch]))

Gem::Specification.new do |s|
    s.name = 'ruby_grammar_builder'
    s.version = "#{major}.#{minor}.#{patch}"
    s.date = Date.today
    s.summary = 'A library to generate textmate grammars'
    s.authors = ["Jeff Hykin", "Matthew Fosdick"]
    s.files = Dir["{lib}/**/*.rb", "LICENSE", "*.md"]
    s.homepage = 'https://github.com/jeff-hykin/ruby_grammar_builder.git'
    s.license = 'MIT'
    
    s.add_runtime_dependency 'deep_clone', '~> 0.0.1', '>= 0.0.1'
    s.required_ruby_version = '>=2.5.0'

    s.metadata = {
        "yard.run" => "yri",
    }
end