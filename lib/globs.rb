require "globs/version"

module Globs
  extend self

  def expand(string)
    string
      .split(/\{|\}/)
      .map { |cs| interpret_glob_set(cs.split(/, */)) }
      .reduce { |sets, cs|
        sets.flat_map { |s| cs.map { |c| s + c } }
      }
  end

  private def interpret_glob_set(set)
    set.flat_map { |s| s.include?('..') ? Range.new(*s.split('..')).to_a : s }
  end
end
