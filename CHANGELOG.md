# Hanami::RSpec

RSpec support for Hanami

## v2.2.0.beta1 - 2024-07-16

### Changed

- Drop support for Ruby 3.0

## v2.1.0 - 2024-02-27

## v2.1.0.rc3 - 2024-02-16

## v2.1.0.rc2 - 2023-11-08

### Added

- [Tim Riley] Skip generating tests for `hanami generate` when `--skip-tests` CLI option is given.
- [Tim Riley] Install Capybara and generate `spec/support/capybara.rb` in `hanami install` hook.

### Changed

- [Tim Riley] Add explanatory code comments to `spec/support/rspec.rb` generated in `hanami install` hook.

## v2.1.0.rc1 - 2023-11-01

### Added

- [Luca Guidi] Generate spec for `hanami generate part` command

### Changed

- [Luca Guidi] Default request spec to expect 404, now that `hanami new` doesn't generate a default root route anymore

## v2.1.0.beta1 - 2023-06-29

## v2.0.1 - 2022-12-25

### Added

- [Luca Guidi] Official support for Ruby 3.2

## v2.0.0 - 2022-11-22

### Added

- [Tim Riley] Use Zeitwerk to autoload the gem
- [Luca Guidi] Support RSpec 3.12

## v2.0.0.rc1 - 2022-11-08

### Changed

- [Luca Guidi] Follow `hanami` versioning

## v3.11.0.beta4 - 2022-10-24

### Changed

- [Luca Guidi] Generate slice specs under `spec/slices/[slice_name]/` (#9)

## v3.11.0.beta3 - 2022-09-21

### Added

- [Luca Guidi] Hook into `hanami new` and `hanami generate` to respect name pluralization
- [Luca Guidi] Hook into `hanami generate action` to generate action specs

## v3.11.0.beta2 - 2022-08-16

### Added

- [Luca Guidi] Hook into `hanami generate slice` to generate a slice directory in spec/ along with a placeholder base action spec [#5]

## v3.11.0.beta1 - 2022-07-20

### Added

- [Luca Guidi] Hook into `hanami install` to setup RSpec + Rack::Test
