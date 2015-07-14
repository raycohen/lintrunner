module Lintrunner
  module Parser
    class Ignore

      # Used to parse the messages in the ignore flag:
      # app/styles/responsive/details/_gift_registry.scss:14 Name of function `image_url` should be written in all lowercase letters with hyphens instead of underscores (NameFormat)
      # app/styles/responsive/details/_gift_registry.scss:20 Rule declaration should be followed by an empty line (EmptyLineBetweenBlocks)
      # @param [Array<String>] ignore_messages An array of messages to ignore
      def parse(ignore_messages)
        messages = []
        ignore_messages.each do |line|

          match = /(?<filename>.*):(?<line>\d*) (?<description>.*) \((?<name>.*)\)/.match(line)
          if match
            messages << Lintrunner::Message.new(
              filename: match[:filename],
              line: match["line"].to_i,
              name: match["name"],
              description: match["description"])
          end
        end
        messages
      end

    end
  end
end
