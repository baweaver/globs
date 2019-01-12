require "globs/version"

# Container for Globs methods, currently only static as the public api
# footprint is relatively small.
#
# It should be noted that I'll be exceptionally verbose in the comments
# of this code as it's an interesting usecase for learning to combine
# map, flat_map, and reduce for permutation-type generators.
#
# More than likely I'll write a tutorial on how the code works later and
# link to it in these comments for the exceptionally curious. It'd be roughly
# a 2.5 / 5 for difficulty.
#
# @author baweaver
# @since 0.0.1
#
module Globs
  extend self

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
  # @example
  #
  #   ```
  #   Globs.expand("test.{a, b}.{1, 2}.com")
  #   => ["test.a.1.com", "test.a.2.com", "test.b.1.com", "test.b.2.com"]
  #   ```
  #
  # @note
  #   While this _could_ be made into a tokenization type process for speed
  #   reasons there's very little reason to do so immediately. The current
  #   implementation is far more proof of concept than anything.
  #
  #   If speed needs to happen to arise from usage, PRs are welcome to
  #   optimize this method, but the public api should remain the same.
  #
  # @param string [String]
  #   Glob-like string to be expanded
  #
  # @return [Array[String]]
  #   All expansions of the glob-like string
  def expand(string)
    string
      .split(/\{|\}/)
      .map { |cs| interpret_glob_set(cs.split(/, */)) }
      .reduce { |sets, cs|
        sets.flat_map { |s| cs.map { |c| s + c } }
      }
  end

  # Interprets a set of glob expressions, looking for items like ranges. When
  # it finds such an item, it expands the range into an array to flatten into
  # the set of possible values for a section.
  #
  # @param set [Array[String]]
  #   Unexpanded glob set
  #
  # @return [Array[String]]
  #   Fully expanded glob sets
  private def interpret_glob_set(set)
    set.flat_map { |s| s.include?('..') ? Range.new(*s.split('..')).to_a : s }
  end
end
