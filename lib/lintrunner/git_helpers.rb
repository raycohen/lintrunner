module Lintrunner
  module GitHelpers
    def git_common_ancestor
      git.merge_base('master', 'HEAD')
    end

    def git_changeset
      git.diff(git_common_ancestor, 'HEAD', context_lines: 10000).find_similar!
    end
  end
end
