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
            fs.write(
              "spec/slices/#{slice}/views/parts/#{context.underscored_name}_spec.rb",
              t("part_slice_spec.erb", context)
            )
          else
            fs.write(
              "spec/views/parts/#{context.underscored_name}_spec.rb",
              t("part_spec.erb", context)
            )
          end
        end

        private

        attr_reader :fs

        attr_reader :inflector

        # @api private
        # @param controller [Array<String>]
        def controller_directory(controller)
          fs.join(controller)
        end

        def template(path, context)
          require "erb"

          ERB.new(
            File.read(__dir__ + "/part/#{path}")
          ).result(context.ctx)
        end

        alias_method :t, :template
      end
    end
  end
end
