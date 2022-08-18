# frozen_string_literal: true

require "erb"
require "hanami/cli/generators/app/action_context"

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
            # TODO: implement
          else
            fs.write(
              "spec/actions/#{controller.join(::File::SEPARATOR)}/#{action}_spec.rb",
              t("action_spec.erb", context)
            )
          end
        end

        private

        attr_reader :fs

        attr_reader :inflector

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
