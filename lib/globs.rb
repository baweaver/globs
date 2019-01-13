require "globs/version"

# Container for Globs methods, currently only static as the public api
# footprint is relatively small.
#
# @author baweaver
# @since 0.0.1
#
module Globs
  extend self

  # Opening brace of a Glob expression
  OPENING_BRACE         = /\{/

  # Closing brace of a Glob expression
  CLOSING_BRACE         = /\}/

  # StringScanner is not 0 indexed. Offset for index.
  SCANNER_INDEX_OFFSET  = 1

  # We don't want to include the brace in our final set, so offset the index
  # to compensate
  BRACE_POSITION_OFFSET = 1

  # Full positional offset for the braces and scanner's non-zero index
  POSITION_OFFSET       = SCANNER_INDEX_OFFSET + BRACE_POSITION_OFFSET

  # End of the string position, used to clarify difference between
  # explicit EOS and positional offsets
  END_OF_STRING         = -1

  # Shorthand for `puts expand(str)` for outputting to STDOUT for
  # unix-like piping.
  #
  # @since 0.0.2
  #
  # @param string [String]
  #   Glob-like string to be expanded
  #
  # @return [NilClass]
  #   Only outputs to STDOUT, returning `nil` from the actual
  #   method call
  def puts(string)
    puts expand(string)
  end

  # Expands a glob-like string into all possible interpretations of it.
  #
  # @since 0.0.1
  #
  # @note
  #   Modified to use StringScanner in 0.0.3 for more accurate tokenization
  #
  # @example
  #
  #   ```
  #   Globs.expand("test.{a, b}.{1, 2}.com")
  #   => ["test.a.1.com", "test.a.2.com", "test.b.1.com", "test.b.2.com"]
  #   ```
  #
  # @param string [String]
  #   Glob-like string to be expanded
  #
  # @return [Array[String]]
  #   All expansions of the glob-like string
  def expand(string)
    scanner = StringScanner.new(string)
    results = ['']

    until scanner.eos?
      beginning     = scanner.pos
      start, finish = next_expression_positions!(scanner)

      # There are no further expressions in the string if the start position is
      # negative.
      #
      # Proceed to move the scanner's cursor to the end of the string and take
      # the rest of the string to append to the current result items.
      if start.negative?
        scanner.pos  = string.size

        non_glob_str = string[beginning..END_OF_STRING]
        expressions  = ['']
      else
        non_glob_str = string[beginning..(start - POSITION_OFFSET)]
        expressions  = interpret_expression(string[start..finish])
      end

      resulting_expressions = expressions.map { |exp| non_glob_str + exp }

      results = results.flat_map { |res|
        resulting_expressions.map { |exp| res + exp }
      }
    end

    results
  end

  # Finds the beginning and end of the next expression set in the string. If
  # an expression set is not found, it will return END_OF_STRING for either
  # of the positions being absent.
  #
  # @since 0.0.3
  #
  # @mutates
  #
  # @note
  #   This will mutate the given StringScanner and cause it to move its
  #   associated cursor to the end of the last-found expression.
  #
  #   If an expression is not found, it will register the last known beginning
  #   position, as `scan_until` will simply return nil and not change the
  #   cursor position if something is not found.
  #
  # @param scanner [StringScanner]
  #   Current StringScanner being used to tokenize and scan the glob expression
  #   string
  #
  # @return [Array[Integer, Integer]]
  #   Starting and ending positions of the next expression, excluding braces
  private def next_expression_positions!(scanner)
    return [END_OF_STRING, END_OF_STRING] unless scanner.scan_until(OPENING_BRACE)
    start = scanner.pos

    return [start, END_OF_STRING] unless scanner.scan_until(CLOSING_BRACE)
    finish = scanner.pos

    [start, finish - POSITION_OFFSET]
  end

  # Interprets a glob expression to extract permutatable items from it.
  #
  # @since 0.0.3
  #
  # @param string [String]
  #   String to interpret as a glob expression
  #
  # @return [Array[String]]
  #   Collection of permutable strings to iterate over when constructing a
  #   final glob set
  private def interpret_expression(string)
    string
      .split(/, */)
      .flat_map { |exp|
        exp.include?('..') ? Range.new(*exp.split('..')).to_a : exp
      }
  end
end
