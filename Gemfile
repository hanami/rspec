# frozen_string_literal: true

source "https://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", require: false, platforms: :mri
  gem "yard",   require: false
end

gem "dry-files",  require: false, github: "dry-rb/dry-files", branch: "main"
gem "dry-logger", require: false, github: "dry-rb/dry-logger", branch: "main"

gem "hanami-utils", require: false, github: "hanami/utils", branch: "main"
gem "hanami-cli",   require: false, github: "hanami/cli", branch: "main"
gem "hanami",       require: false, github: "hanami/hanami", branch: "main"
