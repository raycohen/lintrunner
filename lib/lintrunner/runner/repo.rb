module Lintrunner
  module Runner
    class Repo < Base

      def run(reporter = nil)
        warnings = []
        files.each do |filename|
          # next if patch.delta.binary?
          full_path = File.join(path, filename)
          next unless filename =~ match

          messages = executor.execute(full_path, filename: filename)
          warnings.concat messages
          output = messages.collect do |message|
            reporter.report(message)
          end
        end
        warnings
      end

      private

      def files
        files = []
        git.lookup(git.head.target).tree.walk_blobs { |root, entry| files << "#{root}#{entry[:name]}" }
        files
      end

    end
  end
end
