module Lintrunner
  module GitHelpers
    def git_common_ancestor
      git.merge_base('master', 'HEAD')
    end

    def git_changeset
      git.diff(git_common_ancestor, 'HEAD', context_lines: 10000).find_similar!
    end

    # Get current branch
    # https://github.com/libgit2/rugged/issues/314
    # If pointing at sha, return that sha.
    def current_branch
      git.head.name == "HEAD" ? git.head.target : git.head.name.sub(/^refs\/heads\//, '')
    end
  end
end
