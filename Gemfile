# frozen_string_literal: true

source "https://rubygems.org"
gemspec

unless ENV["CI"]
  gem "byebug", platforms: :mri
  gem "yard"
end

gem "hanami-utils", github: "hanami/utils", branch: "main"
gem "hanami-cli", github: "hanami/cli", branch: "main"
gem "hanami", github: "hanami/hanami", branch: "main"
