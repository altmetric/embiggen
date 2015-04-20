require 'webmock/rspec'

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random
  Kernel.srand config.seed

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

RSpec::Matchers.define :embiggen_to do |expected|
  match do |actual|
    actual.uri == expected
  end

  failure_message do |actual|
    "expected that #{actual.uri} would equal #{expected}"
  end
end
