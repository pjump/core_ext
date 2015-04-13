require "bundler/gem_tasks"

def gemspec
  @gemspec ||= Gem::Specification.load('gemspec.gemspec')
end

def repo_exists?(url)
  @status ||= `curl --head #{Shellwords.escape(url)} 2>/dev/null | head -n1`.split(" ")[1].to_i
  @status < 400
end


task "release" => :github_repo

task :github_repo do
  unless repo_exists?(gemspec.homepage)
    sh %Q{curl -X POST https://api.github.com/user/repos -H "Authorization: token `git config github.token`" -d ' { "name": "#{gemspec.name}" } '}
  end
  sh *%w[git remote add origin], "git@github.com:#{`git config github.user`.chomp}/#{gemspec.name}"
  sh *%w[git push --set-upstream origin master]
end



task :default => :test

namespace :tup do
  directory 'bin'
  file "Tupfile" => ['Rakefile', 'bin/test_stats_collector.sh'] do |t|

    #ruby_env = " GEM_HOME=#{ENV['GEM_HOME']} GEM_PATH=#{ENV['GEM_PATH']} PATH=#{ENV['PATH']} "

    bundler_path = `bundle show bundle`.chomp
    bundle_exec = " ruby -I #{bundler_path}/lib #{bundler_path}/bin/bundle exec "

    mkdir_p 'tupinfo'

    string = <<-EOF.gsub(/^ {6}/,'')
      include tupinfo/tests.tup
      include tupinfo/specs.tup
      export GEM_HOME
      export GEM_PATH
      export PATH
      BUNDLE_EXEC = #{bundle_exec}
      TEST_CMD = ruby -Ilib:test 
      SPEC_CMD = rspec --color --tty
      : foreach $(TESTS) |> $(BUNDLE_EXEC) $(TEST_CMD) %f >| %o || echo "Failed with: $?" >> %o; cat %o |> %f.txt {test_outputs}
      : foreach $(SPECS) |> $(BUNDLE_EXEC) $(SPEC_CMD) %f >| %o || echo "Failed with: $?" >> %o; cat %o |> %f.txt {spec_outputs}
      : {test_outputs} |> exe/test_stats_collector.sh test/succeeding_tests.txt test/failing_tests.txt %f |> test/succeeding_tests.txt test/failing_tests.txt
      : {spec_outputs} |> exe/test_stats_collector.sh spec/succeeding_specs.txt spec/failing_specs.txt %f |> spec/succeeding_specs.txt spec/failing_specs.txt
      EOF
      File.write(t.name, string)
  end
  file "exe/test_stats_collector.sh" => ['bin', 'Rakefile'] do |t|
    File.write(t.name, <<-EOF.gsub(/^ {6}/,'')
      #!/bin/bash

      #Usage: collect_test_results success_heap.txt failing_heap.txt [result1 result2 ... ]

      success_heap=$1
      failing_heap=$2
      touch "$1" "$2"

      shift; shift

      for arg in "$@"
      do
        if tail -1 "$arg" | grep -q "^Failed"
        then
          cat "$arg" >> "$failing_heap"
        else
          cat "$arg" >> "$success_heap"
        fi
      done
               EOF
              )
    chmod "u+x", t.name
  end

  file '.tup' do
    sh "tup init"
  end

  desc 'Initialize tup'
  task :init => ['.tup','Tupfile', 'tupfiles']

  task "find_tests" do
    sh "find test -name '*_test.rb' -o -name 'test_*.rb' > tupinfo/tests.lst"
    sh "find spec -name '*_spec.rb' > tupinfo/specs.lst"
  end

  task "tupfiles" => "find_tests" do 
    sh "sed 's/^/TESTS += /' < tupinfo/tests.lst > tupinfo/tests.tup"
    sh "sed 's/^/SPECS += /' < tupinfo/specs.lst > tupinfo/specs.tup"
  end


  task "test" => %w[init tupfiles] do
    sh "tup test --quiet"
    mkdir_p "test"
    touch "test/succeeding_tests.txt"
    touch "test/failing_tests.txt"
    sh "cat test/succeeding_tests.txt"
    sh "cat test/failing_tests.txt"
  end
  task "spec" => %w[init tupinfo/specs.tup] do
    sh "tup spec --quiet"
    mkdir_p "spec"
    touch "spec/succeeding_specs.txt"
    touch "spec/failing_specs.txt"
    sh "cat spec/succeeding_specs.txt"
    sh "cat spec/failing_specs.txt"
  end
end

file '.bundle' => '.gemspec.gemspec' do |t|
  sh "bundle | tee > #{t.name}"
end

task 'test' => ['tup:test', 'tup:spec', '.bundle']
