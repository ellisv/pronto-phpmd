require 'pronto'
require 'shellwords'
require 'rexml/document'

module Pronto
  class Phpmd < Runner
    def initialize(patches, commit = nil)
      super

      @executable = ENV['PRONTO_PHPMD_EXECUTABLE'] || 'phpmd'
      @ruleset = ENV['PRONTO_PHPMD_RULESET'] || 'cleancode,codesize,controversial,design,naming,unusedcode'
    end

    def run
      return [] unless @patches

      @patches.select { |patch| valid_patch?(patch) }
        .map { |patch| inspect(patch) }
        .flatten.compact
    end

    def valid_patch?(patch)
      patch.additions > 0 && php_file?(patch.new_file_full_path)
    end

    def inspect(patch)
      path = patch.new_file_full_path.to_s
      run_phpmd(path).map do |offence|
        patch.added_lines.select { |line| line.new_lineno == offence[:line] }
          .map { |line| new_message(offence, line) }
      end
    end

    def run_phpmd(path)
      escaped_executable = Shellwords.escape(@executable)
      escaped_path = Shellwords.escape(path)
      escaped_ruleset = Shellwords.escape(@ruleset)

      xml = `#{escaped_executable} #{escaped_path} xml #{escaped_ruleset}`
      doc = REXML::Document.new(xml)

      doc.elements.collect('pmd/file/violation') do |el|
        line = el.attributes['beginline'].to_i
        next unless line > 0

        { line: line, msg: el.first.to_s.strip }
      end
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      level = :warning

      Message.new(path, line, level, offence[:msg], nil, self.class)
    end

    def php_file?(path)
      File.extname(path) == '.php'
    end
  end
end
