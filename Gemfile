# frozen_string_literal: true

source "https://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", platforms: :mri
  gem "yard"
end

gem "dry-files", github: "dry-rb/dry-files", branch: "main"
gem "dry-logger", github: "dry-rb/dry-logger", branch: "main"
gem "dry-system", github: "dry-rb/dry-system", branch: "main"
gem "dry-auto_inject", github: "dry-rb/dry-auto_inject", branch: "main"

gem "hanami-utils", github: "hanami/utils", branch: "main"
gem "hanami-cli", github: "hanami/cli", branch: "main"
gem "hanami", github: "hanami/hanami", branch: "main"
