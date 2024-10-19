# frozen_string_literal: true

require "database_cleaner/sequel"

# Clean the databases between tests tagged as `:db`
RSpec.configure do |config|
  all_databases = -> {
    slices = [Hanami.app] + Hanami.app.slices.with_nested

    slices.each_with_object([]) { |slice, dbs|
      next unless slice.key?("db.rom")

      dbs.concat slice["db.rom"].gateways.values.map(&:connection)
    }.uniq
  }

  config.before :suite do
    all_databases.call.each do |db|
      DatabaseCleaner[:sequel, db: db].clean_with :truncation, except: ["schema_migrations"]
    end
  end

  config.before :each, :db do |example|
    strategy = example.metadata[:js] ? :truncation : :transaction

    all_databases.call.each do |db|
      DatabaseCleaner[:sequel, db: db].strategy = strategy
      DatabaseCleaner[:sequel, db: db].start
    end
  end

  config.after :each, :db do
    all_databases.call.each do |db|
      DatabaseCleaner[:sequel, db: db].clean
    end
  end
end
