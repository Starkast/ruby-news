# frozen_string_literal: true

require "English"

BUILD_CMD = "bundle exec jekyll build --config _config.yml"

desc "Re-build the site when changed"
task :dev do
  sh "rerun --ignore '_site/*' --exit --clear -- "\
     "JEKYLL_ENV=development #{BUILD_CMD}"
rescue RuntimeError
  not_found = $CHILD_STATUS.exitstatus == 127
  abort "Command not found, you probably need to install rerun" if not_found
  raise
end

desc "Build the site"
task :default do
  sh BUILD_CMD
end
