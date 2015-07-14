module Lintrunner
  module Runner
    class Base
      include Lintrunner::GitHelpers

      attr_accessor :path, :match, :executor, :git

      def initialize(path:, match:, executor:)
        self.path = path
        self.executor = executor
        self.match = Regexp.new(Regexp.escape(match))
        self.git = Rugged::Repository.new(path)
      end

      def run(reporter = nil)
        raise "Runner must implement #run method"
      end

    end
  end
end
