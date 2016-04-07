require "lintrunner"
require "lintrunner/options"

module Lintrunner
  class CLI

    # Takes an array of arguments
    # Returns exit code
    def run(args)
      options = Options.new.parse(args)

      handle_options(options)

      path = options[:path]
      context = options[:context]

      # If context is different from path that we want to lint, check that it's up to date
      path != context && is_up_to_date?(context)

      warnings = []

      ignore_messages = Lintrunner::Parser::Ignore.new.parse(options[:ignore])
      reporter = initialize_reporter(options[:reporter],
        path: path,
        ignore: ignore_messages)

      config_file = File.join(Dir.pwd, options[:config])

      config = JSON.parse(File.read(config_file))
      include_paths(config["include_paths"])
      require_files(config["require"]) if config["require"]

      config["linters"].each do |name, config|
        next if config["disabled"]
        if config["command"] && config["parser"]
          parser = Lintrunner::Parser.const_get(config["parser"]).new
          executor = Lintrunner::Executor.new(
            command: config["command"],
            parser: parser
          )
        else
          executor = Lintrunner::Executor.new(
            plugin: Lintrunner::Plugin.const_get(config["plugin"])
          )
        end

        runner = Lintrunner::Runner.const_get(config["runner"]).new(
          path: path,
          match: config["match"],
          executor: executor
        )
        reporter.start(name)
        results = runner.run(reporter)
        reporter.finish(results)
        warnings.concat(results)
      end
      ignored_warnings = []

      unless ignore_messages.empty?
        warnings = warnings.reject do |warning|
          ignore_messages.any? {|im| im == warning}.tap do |is_ignored|
            ignored_warnings << warning if is_ignored
          end
        end
      end
      reporter.wrap_up(ignored_warnings)
      exit warnings.empty? ? 0 : 1
    end

    private

    def initialize_reporter(reporter, options)
      Lintrunner::Reporter.const_get(reporter.capitalize).new(options)
    end

    def handle_options(options)

    end

    def is_up_to_date?(path)
      return # disable until we can use new version of rugged
      context_repo = Rugged::Repository.new(path)
      return unless context_repo.branches['master'].head?
      return if context_repo.branches['master'].upstream.nil?
      Dir.chdir path do
        # update remote ref
        `git fetch #{context_repo.branches['master'].upstream.name.split("/").join(" ")} > /dev/null 2>&1`
        status_output = `git status`
        if status_output =~ /Your branch is behind .* and can be fast-forwarded./

          puts "Repo is not up to date!".color(:red)
          puts "Would you like to update it (Y/N)?"
          input = STDIN.gets
          if input.strip == "Y"
            `git pull --ff-only #{context_repo.branches['master'].upstream.name.split("/").join(" ")}`
          else
            exit 1
          end
        end
      end
    rescue Rugged::RepositoryError => e
      # noop
    end

    def include_paths(include_paths = [])
      $:.unshift(*include_paths)
    end

    def require_files(files)
      files.each do |file|
        require file
      end
    end
  end
end
