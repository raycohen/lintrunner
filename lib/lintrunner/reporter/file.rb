module Lintrunner
  module Reporter
    class File < Base

      def finish(messages)
        messages = messages.reject {|message| ignore?(message)}
        puts messages.collect(&:filename).uniq.join("\n") if messages.any?
      end

    end
  end
end
