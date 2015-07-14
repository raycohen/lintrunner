module Lintrunner
  module Parser
    class Rubocop

      # Example output of rubocop (using the json formatter):
      # {
      #   "metadata": {
      #     "rubocop_version": "0.32.1",
      #     "ruby_engine": "ruby",
      #     "ruby_version": "2.1.1",
      #     "ruby_patchlevel": "76",
      #     "ruby_platform": "x86_64-darwin14.0"
      #   },
      #   "files": [
      #     {
      #       "path": "lib\/lintrunner\/options.rb",
      #       "offenses": [
      #         {
      #           "severity": "warning",
      #           "message": "Remove debugger entry point `binding.pry`.",
      #           "cop_name": "Lint\/Debugger",
      #           "corrected": null,
      #           "location": {
      #             "line": 73,
      #             "column": 22,
      #             "length": 11
      #           }
      #         }
      #       ]
      #     }
      #   ],
      #   "summary": {
      #     "offense_count": 1,
      #     "target_file_count": 1,
      #     "inspected_file_count": 1
      #   }
      # }
      def parse(output, exit_code, options = {})
        return [] unless exit_code == 1

        messages = []
        JSON.parse(output)["files"].each do |file_results|
          filename = file_results["path"]
          file_results["offenses"].each do |lint|
            messages << Lintrunner::Message.new(
              filename: options[:filename] || filename,
              line: lint["location"]["line"],
              name: lint["cop_name"],
              description: lint["message"])
          end
        end
        messages
      end

    end
  end
end
