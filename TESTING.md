# TESTING

This repo currently depends on `tup` for testing.

Tests are treated as file tasks that map a test file to a test output.
`Rake` is used to invoke `tup` to run these test tasks.
`Tup`'s role is that of a dependency tracker.

`Tup` keeps track of file reads issued during each test. A particular test will not be invoked again unless some of the files it read during its last run are newer than the last test output. 

This saves time wasted on useless test runs as long as your tests are deterministic. Fortunately most unit tests are.

# Deterministicness

For this work, your tests must be deterministic. That means:
  - no random input
  - no testing against real-world net (static mocks only)
  - no error-fraught C-extensions
  - no dependence on dynamic stuff such as the current time

Most unit tests abide by these rules.

# Bundler
You need a patched bundler that supports the `glob` option to `gemspec` or else `bundle exec` will issue reads to every file in the repo, rendering the `tup` setup useless.

# Dark Corners of Tup

Unfortunately, tup brings in a couple of somewhat arbitrary (for testing purposes anyway) rules of its own. Mainly that tests must not tread on each other's output. (that means no shared testing databases, for example -- each test must have its own). I hope to fix this by adding dependency tracking to Rake instead, when I have time.
