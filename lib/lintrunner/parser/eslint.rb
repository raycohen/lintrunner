module Lintrunner
  module Parser
    class Eslint < Base

      # Example output of eslint (using the compact formatter):
      # app/javascripts/delivery_page/components/add_guests.js: line 256, col 5, Error - Missing semicolon. (semi)
      # app/javascripts/delivery_page/components/add_guests.js: line 277, col 18, Error - Props should be sorted alphabetically (react/jsx-sort-props)
      def parse(output, exit_code, options = {})
        return [] unless exit_code == 1

        messages = []
        output.each_line do |line|

          match = /(?<filename>.*): line (?<line>\d*), .*Error - (?<description>.*) \((?<name>.*)\)/.match(line)
          if match
            messages << Lintrunner::Message.new(
              filename: options[:filename] || match[:filename],
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
