# frozen_string_literal: true

require "hanami/cli"
require "shellwords"
require_relative "./generators"

module Hanami
  module RSpec
    module Commands
      class Install < Hanami::CLI::Command
        def call(*)
          fs.cp(
            fs.expand_path("helper.rb", __dir__),
            fs.expand_path(fs.join("spec", "spec_helper.rb"))
          )
        end
      end

      module Generate
        class Slice < Hanami::CLI::Command
          # FIXME: dry-cli kwargs aren't correctly forwarded in Ruby 3
          def call(options, **)
            slice = inflector.underscore(Shellwords.shellescape(options[:name]))

            out.puts "generating #{slice} (rspec)"
            generator = Generators::Slice.new(fs: fs, inflector: inflector)
            generator.call(slice)
          end
        end
      end
    end
  end
end

# FIXME: define hanami-cli public API
if Hanami.app?
  Hanami::CLI.after "install", Hanami::RSpec::Commands::Install
  # Hanami::CLI.after "generate slice", Hanami::RSpec::Commands::Generate::Slice
end
