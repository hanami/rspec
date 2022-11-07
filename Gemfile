# frozen_string_literal: true

source "https://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard",   require: false
end

gem "dry-files", require: false, git: "https://github.com/dry-rb/dry-files.git", branch: "main"
gem "dry-logger", require: false, git: "https://github.com/dry-rb/dry-logger.git", branch: "main"
gem "hanami-utils", require: false, git: "https://github.com/hanami/utils.git", branch: "main"
gem "hanami-cli", require: false, git: "https://github.com/hanami/cli.git", branch: "main"
gem "hanami", require: false, git: "https://github.com/hanami/hanami.git", branch: "main"
