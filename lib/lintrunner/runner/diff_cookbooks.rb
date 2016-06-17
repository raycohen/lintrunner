module Lintrunner
  module Runner
    class DiffCookbooks < Base

      def run(reporter)
        warnings = []
        changed_cookbooks = []
        line_maps = {}
        git_changeset.each do |patch|
          filename = patch.delta.new_file[:path]
          next if patch.delta.binary?
          next if patch.delta.renamed?

          if (match = filename.match(/(cookbooks\/[^\/]*)\//))
            changed_cookbooks << match[1]
            line_maps[filename] = line_map_for(patch) if contents_for(patch.delta, :src)
          end
        end

        changed_cookbooks.each do |cookbook, patches|
          before_messages = []
          after_messages = []
          Dir.chdir(path) do
            prev = current_branch
            `git checkout -q #{git_common_ancestor}`
            before_messages = executor.execute(cookbook)
            `git checkout -q #{prev}`
            after_messages = executor.execute(cookbook)
          end

          after_messages.each do |lint|
            same_lint = before_messages.find do |b_lint|
              line = line_maps[lint.filename] ? line_maps[lint.filename][lint.line] : lint.line
              b_lint.line == line && b_lint.name == lint.name && b_lint.description == lint.description
            end
            warnings << lint unless same_lint
            reporter.report(lint) unless same_lint
          end
        end
        warnings
      end

    end
  end
end
