# frozen_string_literal: true

require "erb"

module Hanami
  module RSpec
    module Generators
      class Action
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        def call(app, slice, controller, action, context: Hanami::CLI::Generators::App::ActionContext.new(inflector, app, slice, controller, action)) # rubocop:disable Layout/LineLength
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

        def template(path, context)
          require "erb"

          ERB.new(
            File.read(__dir__ + "/action/#{path}")
          ).result(context.ctx)
        end

        alias_method :t, :template
      end
    end
  end
end
