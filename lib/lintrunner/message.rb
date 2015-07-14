module Lintrunner
  class Message

    attr_accessor :filename, :line, :name, :description

    def initialize(filename:, line:, name:, description:)
      self.filename = filename
      self.line = line
      self.name = name
      self.description = description
    end

    def ==(other)
      other.filename == self.filename && other.line == self.line && other.name == self.name &&
        other.description == self.description
    end

  end
end
