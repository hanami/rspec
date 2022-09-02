# frozen_string_literal: true

require "hanami/cli"
require "shellwords"
require "hanami/cli/commands/app/command"
require "hanami/cli/generators/context"
require_relative "./generators"

module Hanami
  module RSpec
    module Commands
      class Install < Hanami::CLI::Command
        def call(*, **)
          append_gemfile
          copy_dotrspec
          copy_spec_helper
          copy_support_rspec
          copy_support_requests

          generate_request_spec
        end

        private

        def append_gemfile
          fs.append(
            fs.expand_path("Gemfile"),
            fs.read(
              fs.expand_path(fs.join("generators", "gemfile"), __dir__)
            ),
          )
        end

        def copy_dotrspec
          fs.cp(
            fs.expand_path(fs.join("generators", "dotrspec"), __dir__),
            fs.expand_path(fs.join(".rspec")),
          )
        end

        def copy_spec_helper
          fs.cp(
            fs.expand_path(fs.join("generators", "helper.rb"), __dir__),
            fs.expand_path(fs.join("spec", "spec_helper.rb"))
          )
        end

        def copy_support_rspec
          fs.cp(
            fs.expand_path(fs.join("generators", "support_rspec.rb"), __dir__),
            fs.expand_path(fs.join("spec", "support", "rspec.rb"))
          )
        end

        def copy_support_requests
          fs.cp(
            fs.expand_path(fs.join("generators", "support_requests.rb"), __dir__),
            fs.expand_path(fs.join("spec", "support", "requests.rb"))
          )
        end

        def generate_request_spec
          fs.cp(
            fs.expand_path(fs.join("generators", "request.rb"), __dir__),
            fs.expand_path(fs.join("spec", "requests", "root_spec.rb"))
          )
        end
      end

      module Generate
        class Slice < Hanami::CLI::Command
          # FIXME: dry-cli kwargs aren't correctly forwarded in Ruby 3
          def call(options, **)
            slice = inflector.underscore(Shellwords.shellescape(options[:name]))

            generator = Generators::Slice.new(fs: fs, inflector: inflector)
            generator.call(slice)
          end
        end

        class Action < Hanami::CLI::Commands::App::Command
          # FIXME: dry-cli kwargs aren't correctly forwarded in Ruby 3
          def call(options, **)
            slice = inflector.underscore(Shellwords.shellescape(options[:slice])) if options[:slice]
            name = inflector.underscore(Shellwords.shellescape(options[:name]))
            *controller, action = name.split(ACTION_SEPARATOR)

            generator = Generators::Action.new(fs: fs, inflector: inflector)
            generator.call(app.namespace, slice, controller, action)
          end
        end
      end
    end
  end
end

if Hanami::CLI.within_hanami_app?
  Hanami::CLI.after "install", Hanami::RSpec::Commands::Install
  Hanami::CLI.after "generate slice", Hanami::RSpec::Commands::Generate::Slice
  Hanami::CLI.after "generate action", Hanami::RSpec::Commands::Generate::Action
end
