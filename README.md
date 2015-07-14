# Lintrunner
Run multiple lints with various runners.

---

This is still currently a work in progress. However, it should be functional enough to run linters with various runners such as `Diff`, or `Repo`.

To try it out, clone this repo, run `bundle install` and make sure you have `scss-lint`, `rubocop`, and `eslint` installed locally.

Then simply run `./bin/lintrunner` to see this in action. More documentation coming soon.

The output:

```
Running scss linters
No messages found

Running rubocop linters
example_plugin.rb:43 Remove debugger entry point `binding.pry`. (Lint/Debugger)

Running eslint linters
No messages found

```
