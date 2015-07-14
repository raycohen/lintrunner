# Reporters are responsible for generating the output of lintrunner
# Default behavior is noop for #start, #report, and #finish
module Lintrunner
  module Reporter
    class Base

      attr_reader :options

      def initialize(options)
        @options = options
      end

      # Called when a lintrunner is started
      # @param [String] name The name of the lintrunner (ex. "binding.pry check")
      def start(name); end

      # Called when a message is discovered from the lintrunner
      # @param [Lintrunner::Message] message
      def report(message); end

      # Called when the lintrunner is finished executing
      # @param [Array<Lintrunner::Message>] messages
      def finish(messages); end

      # The description of this reporter. Used for CLI when listing possible reporters
      def description; end

      def wrap_up(ignored); end

      def ignore?(message)
        options[:ignore].any? {|im| im == message}
      end

    end
  end
end
