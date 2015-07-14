# Parsers are responsible for parsing the output of a linter command and returning an array of
# Lintrunner::Message for each warning produced
module Lintrunner
  module Parser
    class Base

      # Parse the output of a linter so that lintrunner can understand what the warnings are
      # @param [String] output The output of running the linter command
      # @param [Integer] exit_code The exit code of the linter command
      # @param [Hash] options
      # @option opts [String] :filename Allow the caller to set the filename of the results
      # @return [Array<Lintrunner::Message>] An array of warnings produced by the linter command
      def parse(output, exit_code, options = {})
        raise "Parser must implement #parser method"
      end

    end
  end
end
