module Lintrunner
  module Plugin
    class BindingPryCheck

      attr_accessor :filename

      def initialize(filename)
        self.filename = filename
        @binding_pry_matcher = /binding\.pry/
      end

      def run(options = {})
        lineno = 1
        warnings = []
        return warnings if binary?(filename)
        File.read(filename).each_line do |line|
          warnings << create_message(options[:filename] || filename, lineno) if line[@binding_pry_matcher]
          lineno += 1
        end
        warnings
      end

      def create_message(filename, lineno)
        Lintrunner::Message.new(
          filename: filename,
          line: lineno,
          name: "BindingPryCheck",
          description: "binding.pry detected"
        )
      end

      def binary?(file)
        # return false if image?(file)
        bytes = File.stat(file).blksize
        bytes = 4096 if bytes > 4096
        s = (File.read(file, bytes) || "")
        s = s.encode('US-ASCII', :undef => :replace).split(//)
        ((s.size - s.grep(" ".."~").size) / s.size.to_f) > 0.30
      end

    end
  end
end
