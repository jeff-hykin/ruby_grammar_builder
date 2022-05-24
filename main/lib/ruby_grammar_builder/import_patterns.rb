# frozen_string_literal: true

require 'deep_clone'
require 'yaml'
require_relative '../ruby_grammar_builder/grammar_plugin'
require_relative '../ruby_grammar_builder/util'
require_relative '../ruby_grammar_builder/regex_operator'
require_relative '../ruby_grammar_builder/regex_operators/concat'
require_relative '../ruby_grammar_builder/tokens'

# import Pattern, LegacyPattern, and PatternRange
Dir[File.join(__dir__, 'pattern_variations', '*.rb')].each { |file| require file }
# import .or(), .maybe(), .zeroOrMoreOf(), etc
Dir[File.join(__dir__, 'pattern_extensions', '*.rb')].each { |file| require file }