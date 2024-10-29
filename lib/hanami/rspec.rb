# frozen_string_literal: true

require "hanami/cli"
require "zeitwerk"

# @see Hanami::RSpec
# @since 2.0.0
module Hanami
  # RSpec and testing support for Hanami applications.
  #
  # @since 2.0.0
  # @api private
  module RSpec
    # @since 2.0.0
    # @api private
    def self.gem_loader
      @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
        root = File.expand_path("..", __dir__)
        loader.tag = "hanami-rspec"
        loader.inflector = Zeitwerk::GemInflector.new("#{root}/hanami-rspec.rb")
        loader.push_dir(root)
        loader.ignore(
          "#{root}/hanami-rspec.rb",
          "#{root}/hanami/rspec/{rake_tasks,version}.rb"
        )
        loader.inflector.inflect("rspec" => "RSpec")
      end
    end

    gem_loader.setup
    require_relative "rspec/version"
    require_relative "rspec/rake_tasks"

    if Hanami::CLI.within_hanami_app?
      Hanami::CLI.after "install", Commands::Install
      Hanami::CLI.after "generate slice", Commands::Generate::Slice
      
      if Hanami.bundled?("hanami-controller")
        Hanami::CLI.after "generate action", Commands::Generate::Action
      end

      if Hanami.bundled?("hanami-view")
        Hanami::CLI.after "generate part", Commands::Generate::Part
      end
    end
  end
end
