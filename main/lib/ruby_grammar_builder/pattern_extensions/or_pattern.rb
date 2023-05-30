# frozen_string_literal: true

require_relative '../regex_operators/alternation'

# Provides alternation
# Either the previous pattern or provided pattern is accepted
# @note OneOfPattern is likely just as powerful and less confusing
class OrPattern < PatternBase
    #
    # (see PatternBase#evaluate_operator)
    #
    # @return [AlternationOperator] the alternation operator
    #
    def evaluate_operator
        AlternationOperator.new
    end
    
    def run_self_tests
        pass = [true]

        # some patterns are not able to be evaluated
        # do not attempt to unless required
        return true unless [
            :should_fully_match,
            :should_not_fully_match,
            :should_partially_match,
            :should_not_partially_match,
        ].any? { |k| @arguments.include? k }
        
        copy = @match.__deep_clone_self__
        test_regex = copy.to_r
        test_fully_regex = wrap_with_anchors(copy).to_r

        warn = lambda do |symbol|
            puts [
                "",
                "When testing the pattern #{test_regex.inspect}. The unit test for #{symbol} failed.",
                "The unit test has the following patterns:",
                "#{@arguments[symbol].to_yaml}",
                "The Failing pattern is below:",
                "#{self}",
            ].join("\n")
        end
        if @arguments[:should_fully_match].is_a? Array
            unless @arguments[:should_fully_match].all? { |test| test =~ test_fully_regex }
                warn.call :should_fully_match
                pass << false
            end
        end
        if @arguments[:should_not_fully_match].is_a? Array
            unless @arguments[:should_not_fully_match].none? { |test| test =~ test_fully_regex }
                warn.call :should_not_fully_match
                pass << false
            end
        end
        if @arguments[:should_partially_match].is_a? Array
            unless @arguments[:should_partially_match].all? { |test| test =~ test_regex }
                warn.call :should_partially_match
                pass << false
            end
        end
        if @arguments[:should_not_partially_match].is_a? Array
            unless @arguments[:should_not_partially_match].none? { |test| test =~ test_regex }
                warn.call :should_not_partially_match
                pass << false
            end
        end

        pass.none?(&:!)
    end
    
    #
    # Raises an error to prevent use as initial type
    #
    # @param _ignored ignored
    #
    # @return [void]
    #
    def evaluate(*_ignored)
        raise "evaluate is not implemented for OrPattern"
    end

    # (see PatternBase#do_get_to_s_name)
    def do_get_to_s_name(top_level)
        top_level ? "or(" : ".or("
    end

    # (see PatternBase#single_entity?)
    # @return [true]
    def single_entity?
        true
    end
end

class PatternBase
    #
    # Match either the preceding pattern chain or pattern
    #
    # @param [PatternBase,Regexp,String,Hash] pattern a pattern to match
    #   instead of the previous chain
    #
    # @return [PatternBase] a pattern to append to
    #
    def or(pattern)
        insert(OrPattern.new(pattern))
    end
end

# or does not have a top level option