module Lintrunner
  module Parser
    class Brakeman

      # Example output of brakeman (using the json formatter and some values removed to anonymize):
      # {
      #   "scan_info": {
      #     "app_path": "-",
      #     "rails_version": "-",
      #     "security_warnings": 0,
      #     "start_time": "2016-03-03 12:38:03 -0500",
      #     "end_time": "2016-03-03 12:38:36 -0500",
      #     "duration": 33.517324,
      #     "checks_performed": [
      #       "SQL"
      #     ],
      #     "number_of_controllers": 0,
      #     "number_of_models": 0,
      #     "number_of_templates": 0,
      #     "ruby_version": "2.1.1",
      #     "brakeman_version": "3.0.1"
      #   },
      #   "warnings": [
      #     {
      #       "warning_type": "SQL Injection",
      #       "warning_code": 0,
      #       "fingerprint": "-",
      #       "message": "Possible SQL injection",
      #       "file": "-",
      #       "line": 254,
      #       "link": "http://brakemanscanner.org/docs/warning_types/sql_injection/",
      #       "code": "-",
      #       "render_path": null,
      #       "location": {
      #         "type": "method",
      #         "class": "-",
      #         "method": "-"
      #       },
      #       "user_input": "start_time",
      #       "confidence": "Medium"
      #     }
      #   ],
      #   "ignored_warnings": [],
      #   "errors": []
      # }
      def parse(output, exit_code, options = {})
        messages = []
        JSON.parse(output)["warnings"].each do |lint|
          filename = lint["file"]
          messages << Lintrunner::Message.new(
            filename: options[:filename] || filename,
            line: lint["line"],
            name: lint["warning_type"],
            description: lint["message"])
        end
        messages
      end

    end
  end
end
