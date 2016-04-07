module Lintrunner
  module Parser
    class Foodcritic

      # Example output of foodcritic:
      # FC001: Use strings in preference to symbols to access node attributes: cookbooks/acceptance/attributes/default.rb:1
      # FC001: Use strings in preference to symbols to access node attributes: cookbooks/acceptance/attributes/default.rb:2
      # FC001: Use strings in preference to symbols to access node attributes: cookbooks/acceptance/attributes/default.rb:3
      # FC001: Use strings in preference to symbols to access node attributes: cookbooks/acceptance/attributes/default.rb:4
      # FC001: Use strings in preference to symbols to access node attributes: cookbooks/acceptance/attributes/default.rb:5
      # FC001: Use strings in preference to symbols to access node attributes: cookbooks/acceptance/attributes/default.rb:7
      # FC001: Use strings in preference to symbols to access node attributes: cookbooks/acceptance/attributes/default.rb:8
      # FC019: Access node attributes in a consistent manner: cookbooks/acceptance/recipes/default.rb:2
      def parse(output, exit_code, options = {})
        messages = []
        output.each_line do |line|

          match = /(?<name>[^:]*):(?<description>[^:]*):(?<filename>[^:]*):(?<line>\d*)/.match(line)
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
