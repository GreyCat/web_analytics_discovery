require 'rubygems'
require 'bundler/setup'

require 'web_analytics_discovery'
include WebAnalyticsDiscovery

RSpec.configure { |config|
  # some (optional) config here
}

def full_result_check(res)
  expect(res).not_to be_nil

  expect(res[:visitors_day]).not_to be_nil
  expect(res[:visits_day]).not_to be_nil
  expect(res[:pv_day]).not_to be_nil

  expect(res[:visitors_week]).not_to be_nil
  expect(res[:visits_week]).not_to be_nil
  expect(res[:pv_week]).not_to be_nil

  expect(res[:visitors_mon]).not_to be_nil
  expect(res[:visits_mon]).not_to be_nil
  expect(res[:pv_mon]).not_to be_nil
end
