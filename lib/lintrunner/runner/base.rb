module Lintrunner
  module Runner
    class Base
      include Lintrunner::GitHelpers

      attr_accessor :path, :match, :executor, :git

      def initialize(path:, match:, executor:)
        self.path = path
        self.executor = executor
        self.match = Regexp.new(match) if match
        self.git = Rugged::Repository.new(path)
      end

      def run(reporter = nil)
        raise "Runner must implement #run method"
      end

      private

      # Get the file contents of a delta
      # if type=:src, return original file
      # if type=:dst, return modified file
      def contents_for(delta, type = :dst)
        ref = if type == :src
          delta.old_file[:oid]
        elsif type == :dst
          delta.new_file[:oid]
        end
        @git.lookup(ref).content if ref != "0000000000000000000000000000000000000000"
      end

      def line_map_for(patch)
        line_map = []
        patch.hunks.first.lines.each do |line|
          if line.new_lineno != -1
            line_map[line.new_lineno] = line.old_lineno == -1 ? nil : line.old_lineno
          end
        end
        line_map
      end

    end
  end
end
