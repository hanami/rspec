# frozen_string_literal: true

require "erb"

module Hanami
  module RSpec
    module Generators
      # @since 2.0.0
      # @api private
      class Slice
        # @since 2.0.0
        # @api private
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        # @since 2.0.0
        # @api private
        def call(slice, context: Hanami::CLI::Generators::App::SliceContext.new(inflector, nil, slice, nil))
          fs.write("spec/slices/#{slice}/action_spec.rb", t("action_spec.erb", context))
          # fs.write("spec/slices/#{slice}/view_spec.rb", t("view_spec.erb", context))
          # fs.write("spec/slices/#{slice}/repository_spec.rb", t("repository_spec.erb", context))

          fs.write("spec/slices/#{slice}/actions/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/views/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/templates/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/templates/layouts/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/entities/.keep", t("keep.erb", context))
          # fs.write("spec/slices/#{slice}/repositories/.keep", t("keep.erb", context))
        end

        private

        attr_reader :fs

        attr_reader :inflector

        def template(path, context)
          require "erb"

          ERB.new(
            File.read(__dir__ + "/slice/#{path}")
          ).result(context.ctx)
        end

        alias_method :t, :template
      end
    end
  end
end
