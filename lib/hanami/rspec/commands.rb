# frozen_string_literal: true

require "shellwords"

module Hanami
  module RSpec
    # @since 2.0.0
    # @api private
    module Commands
      # @since 2.0.0
      # @api private
      class Install < Hanami::CLI::Command
        # @since 2.0.0
        # @api private
        def call(*, **)
          append_gemfile
          append_gitignore
          copy_dotrspec
          copy_spec_helper
          copy_support_rspec
          copy_support_db
          copy_support_features
          copy_support_operations
          copy_support_requests

          generate_request_spec
        end

        private

        def append_gemfile
          gemfile_template = Hanami.bundled?("hanami-db") ? "gemfile_db" : "gemfile"

          fs.append(
            fs.expand_path("Gemfile"),
            fs.read(fs.expand_path(fs.join("generators", gemfile_template), __dir__))
          )
        end

        def append_gitignore
          fs.append(
            fs.expand_path(".gitignore"),
            fs.read(fs.expand_path(fs.join("generators", "gitignore"), __dir__))
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

        def copy_support_db
          return unless Hanami.bundled?("hanami-db")

          fs.cp(
            fs.expand_path(fs.join("generators/support_db.rb"), __dir__),
            fs.expand_path(fs.join("spec", "support", "db.rb"))
          )

          fs.cp(
            fs.expand_path(fs.join("generators/support_db_cleaning.rb"), __dir__),
            fs.expand_path(fs.join("spec", "support", "db", "cleaning.rb"))
          )
        end

        def copy_support_features
          fs.cp(
            fs.expand_path(fs.join("generators", "support_features.rb"), __dir__),
            fs.expand_path(fs.join("spec", "support", "features.rb"))
          )
        end

        def copy_support_operations
          fs.cp(
            fs.expand_path(fs.join("generators", "support_operations.rb"), __dir__),
            fs.expand_path(fs.join("spec", "support", "operations.rb"))
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

      # @since 2.0.0
      # @api private
      module Generate
        # @since 2.0.0
        # @api private
        class Slice < Hanami::CLI::Command
          # FIXME: dry-cli kwargs aren't correctly forwarded in Ruby 3
          def call(options, **)
            slice = inflector.underscore(Shellwords.shellescape(options[:name]))

            generator = Generators::Slice.new(fs: fs, inflector: inflector)
            generator.call(slice)
          end
        end

        # @since 2.0.0
        # @api private
        class Action < Hanami::CLI::Commands::App::Command
          # @since 2.0.0
          # @api private
          def call(options, **)
            # FIXME: dry-cli kwargs aren't correctly forwarded in Ruby 3

            return if options[:skip_tests]

            slice = inflector.underscore(Shellwords.shellescape(options[:slice])) if options[:slice]
            key = inflector.underscore(Shellwords.shellescape(options[:name]))

            namespace = slice ? inflector.camelize(slice) : app.namespace
            base_path = slice ? "spec/slices/#{slice}" : "spec"

            generator = Generators::Action.new(fs:, inflector:)
            generator.call(key:, namespace:, base_path:)
          end
        end

        # @since 2.1.0
        # @api private
        class Part < Hanami::CLI::Commands::App::Command
          # @since 2.1.0
          # @api private
          def call(options, **)
            # FIXME: dry-cli kwargs aren't correctly forwarded in Ruby 3

            return if options[:skip_tests]

            slice = inflector.underscore(Shellwords.shellescape(options[:slice])) if options[:slice]
            key = inflector.underscore(Shellwords.shellescape(options[:name]))

            namespace = slice ? inflector.camelize(slice) : app.namespace
            base_path = slice ? "spec/slices/#{slice}" : "spec"

            generator = Generators::Part.new(fs: fs, inflector: inflector)
            generator.call(key: key, namespace: namespace, base_path: base_path, app_namespace: app.namespace)
          end
        end
      end
    end
  end
end
