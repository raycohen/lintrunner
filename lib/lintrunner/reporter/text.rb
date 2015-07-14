module Lintrunner
  module Reporter
    class Text < Base

      def start(name)
        puts "Running #{name} linters".underline
      end

      def report(message)
        puts message_output(message) unless ignore?(message)
      end

      def finish(messages)
        messages = messages.reject {|message| ignore?(message)}
        puts "No messages found".color(:green) if messages.empty?
        puts
      end

      def wrap_up(ignored)
        return if ignored.empty?
        puts "The following were ignored".underline
        ignored.each do |message|
          puts message_output(message)
        end
      end

      private

      def message_output(message)
        "#{location(message)} #{message.description} #{message_name(message)}"
      end

      def message_name(message)
        "(#{message.name})".color(:yellow)
      end

      def location(message)
        "#{message.filename.to_s.color(:cyan)}:#{message.line.to_s.color(:green)}"
      end
    end
  end
end
