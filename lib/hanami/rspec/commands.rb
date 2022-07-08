# frozen_string_literal: true

require "hanami/cli"
require "shellwords"
require "hanami/cli/generators/context"
require_relative "./generators"

module Hanami
  module RSpec
    module Commands
      class Install < Hanami::CLI::Command
        def call(app:, **)
          ctx = Hanami::CLI::Generators::Context.new(inflector, app)

          append_gemfile
          copy_dotrspec
          copy_spec_helper
          copy_support_rspec
          copy_support_features

          generate_feature(ctx)
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

        def copy_support_features
          fs.cp(
            fs.expand_path(fs.join("generators", "support_features.rb"), __dir__),
            fs.expand_path(fs.join("spec", "support", "features.rb"))
          )
        end

        def generate_feature(ctx)
          fs.write(
            fs.join("spec", "features", "home_spec.rb"),
            t(fs.expand_path(fs.join("generators", "feature.erb"), __dir__), ctx)
          )
        end

        def template(path, context)
          require "erb"

          ERB.new(
            fs.read(path)
          ).result(context.ctx)
        end

        alias_method :t, :template
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

if Hanami::CLI.within_hanami_app?
  Hanami::CLI.after "install", Hanami::RSpec::Commands::Install
  # Hanami::CLI.after "generate slice", Hanami::RSpec::Commands::Generate::Slice
end
