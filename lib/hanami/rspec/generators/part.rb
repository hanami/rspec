# frozen_string_literal: true

require "erb"

module Hanami
  module RSpec
    module Generators
      # @since 2.1.0
      # @api private
      class Part
        # @since 2.1.0
        # @api private
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        # @since 2.1.0
        # @api private
        def call(app, slice, name, context: Hanami::CLI::Generators::App::PartContext.new(inflector, app, slice, name))
          if slice
            generate_for_slice(slice, context)
          else
            generate_for_app(context)
          end
        end

        private

        # @since 2.1.0
        # @api private
        def generate_for_slice(slice, context)
          generate_base_part_for_app(context)
          generate_base_part_for_slice(context, slice)

          fs.write(
            "spec/slices/#{slice}/views/parts/#{context.underscored_name}_spec.rb",
            t("part_slice_spec.erb", context)
          )
        end

        # @since 2.1.0
        # @api private
        def generate_for_app(context)
          generate_base_part_for_app(context)

          fs.write(
            "spec/views/parts/#{context.underscored_name}_spec.rb",
            t("part_spec.erb", context)
          )
        end

        # @since 2.1.0
        # @api private
        def generate_base_part_for_app(context)
          path = fs.join("spec", "views", "part_spec.rb")
          return if fs.exist?(path)

          fs.write(
            path,
            t("part_base_spec.erb", context)
          )
        end

        # @since 2.1.0
        # @api private
        def generate_base_part_for_slice(context, slice)
          path = "spec/slices/#{slice}/views/part_spec.rb"
          return if fs.exist?(path)

          fs.write(
            path,
            t("part_slice_base_spec.erb", context)
          )
        end

        # @since 2.1.0
        # @api private
        attr_reader :fs

        # @since 2.1.0
        # @api private
        attr_reader :inflector

        # @since 2.1.0
        # @api private
        def template(path, context)
          require "erb"

          ERB.new(
            File.read(__dir__ + "/part/#{path}")
          ).result(context.ctx)
        end

        # @since 2.1.0
        # @api private
        alias_method :t, :template
      end
    end
  end
end
