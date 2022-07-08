# frozen_string_literal: true

require "erb"
require "hanami/cli/generators/app/slice_context"

module Hanami
  module RSpec
    module Generators
      class Slice
        def initialize(fs:, inflector:)
          @fs = fs
          @inflector = inflector
        end

        def call(slice, context: Hanami::CLI::Generators::App::SliceContext.new(inflector, nil, slice, nil)) # rubocop:disable Metrics/AbcSize
          fs.write("spec/#{slice}/action_spec.rb", t("action_spec.erb", context))
          fs.write("spec/#{slice}/view_spec.rb", t("view_spec.erb", context))
          fs.write("spec/#{slice}/repository_spec.rb", t("repository_spec.erb", context))

          fs.write("spec/#{slice}/actions/.keep", t("keep.erb", context))
          fs.write("spec/#{slice}/views/.keep", t("keep.erb", context))
          fs.write("spec/#{slice}/templates/.keep", t("keep.erb", context))
          fs.write("spec/#{slice}/templates/layouts/.keep", t("keep.erb", context))
          fs.write("spec/#{slice}/entities/.keep", t("keep.erb", context))
          fs.write("spec/#{slice}/repositories/.keep", t("keep.erb", context))
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
