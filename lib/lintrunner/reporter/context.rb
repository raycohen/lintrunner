module Lintrunner
  module Reporter
    class Context < Text

      def report(message)
        return if ignore?(message)
        puts "#{location(message)} #{message.description} #{message_name(message)}"
        puts context(message)
        puts
      end

      private

      def context(message)
        lineno = message.line - 1
        start = lineno > 2 ? lineno - 3 : 0
        range = start..(message.line + 2)
        lines = ::File.readlines(::File.join(options[:path], message.filename))[range]
        message_index = lineno - start
        lines[message_index] = lines[message_index].color(:red)
        lines.join
      end
    end
  end
end
