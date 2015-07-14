# Encapsulates how to execute a lint either through a command line string with a parser or with a plugin
module Lintrunner
  class Executor

    attr_reader :command, :parser, :plugin

    def initialize(options = {})
      @command = options[:command]
      @parser = options[:parser]
      @plugin = options[:plugin]
    end

    def execute(filename, options = {})
      if command && parser
        output = `#{command} #{filename} 2>/dev/null`
        exit_code = $?.exitstatus
        parser.parse(output, exit_code, options)
      elsif plugin
        plugin.new(filename).run(options)
      end
    end
  end
end
