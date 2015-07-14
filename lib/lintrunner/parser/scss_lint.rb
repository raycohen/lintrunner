module Lintrunner
  module Parser
    class SCSSLint

      # Example output of scss-lint (using the json formatter):
      # {
      #   "app/styles/pages/delivery/_add_guests.scss": [
      #     {
      #       "line": 9,
      #       "column": 14,
      #       "length": 16,
      #       "severity": "warning",
      #       "reason": "Shorthand form for property `padding` should be written more concisely as `32px 70px 0` instead of `32px 70px 0 70px`",
      #       "linter": "Shorthand"
      #     }
      #   ]
      # }
      def parse(output, exit_code, options = {})
        return [] unless exit_code == 1

        messages = []
        JSON.parse(output).each do |filename, lints|
          lints.each do |lint|
            messages << Lintrunner::Message.new(
              filename: options[:filename] || filename,
              line: lint["line"],
              name: lint["linter"],
              description: lint["reason"])
          end
        end
        messages
      end

    end
  end
end
