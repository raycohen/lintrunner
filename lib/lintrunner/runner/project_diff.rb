module Lintrunner
  module Runner
    class ProjectDiff < Base

      def run(reporter = nil)
        warnings = []
        before_messages = []
        after_messages = []
        Dir.chdir(path) do
          prev_sha = git.head.target
          `git checkout -q #{git_common_ancestor}`
          before_messages = executor.execute(nil)
          `git checkout -q #{prev_sha}`
          after_messages = executor.execute(nil)
        end

        after_messages.each do |lint|
          patch = git_changeset.select { |patch|  patch.delta.new_file[:path] == lint.filename }.first
          line = lint.line
          if patch
            line_map = line_map_for(patch)
            line = line_map[lint.line]
          end
          same_lint = before_messages.find do |b_lint|
            b_lint.line == line &&
              b_lint.name == lint.name && b_lint.description == lint.description
          end
          warnings << lint unless same_lint
          reporter.report(lint) unless same_lint
        end
        warnings
      end

    end
  end
end
