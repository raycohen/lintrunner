module Lintrunner
  module Runner
    class ChangedFile < Base

      def run(reporter)
        warnings = []
        git_changeset.each do |patch|
          filename = patch.delta.new_file[:path]
          next if patch.delta.binary?
          next unless filename =~ match
          full_path = File.join(path, filename)

          messages = executor.execute(full_path, filename: filename, path: path)
          warnings.concat messages
          output = messages.collect do |message|
            reporter.report(message)
          end
        end
        warnings
      end

    end
  end
end
