# frozen_string_literal: true

require "hanami/cli"

module Hanami
  module RSpec
    module Commands
      class Install < Hanami::CLI::Command
        def call(*)
          out.puts "rspec.."
        end
      end
    end
  end
end

# FIXME: define hanami-cli public API
if Hanami.architecture
  Hanami::CLI.after "install", Hanami::RSpec::Commands::Install
end
