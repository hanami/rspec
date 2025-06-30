# frozen_string_literal: true

require "erb"

module Hanami
  module RSpec
    module Generators
      # @since 2.0.0
      # @api private
      class Action
        # @since 2.0.0
        # @api private
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        # @since 2.0.0
        # @api private
        def call(app, slice, controller, action)
          context = Data.define(
            :camelized_app_name,
            :camelized_slice_name,
            :camelized_controller_name,
            :camelized_action_name
          ).new(
            camelized_app_name: inflector.camelize(app),
            camelized_slice_name: slice ? inflector.camelize(slice) : nil,
            camelized_controller_name: camelized_controller_name(controller),
            camelized_action_name: inflector.camelize(action)
          )

          if slice
            fs.write(
              "spec/slices/#{slice}/actions/#{controller_directory(controller)}/#{action}_spec.rb",
              t("action_slice_spec.erb", context)
            )
          else
            fs.write(
              "spec/actions/#{controller_directory(controller)}/#{action}_spec.rb",
              t("action_spec.erb", context)
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

        # @api private
        # @param controller [Array<String>]
        def camelized_controller_name(controller)
          controller.map { |part| inflector.camelize(part) }.join("::")
        end

        def template(path, context)
          require "erb"

          ERB.new(
            File.read(__dir__ + "/action/#{path}")
          ).result(context.instance_eval { binding })
        end

        alias_method :t, :template
      end
    end
  end
end
