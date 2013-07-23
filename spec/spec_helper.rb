require 'rubygems'
require 'bundler/setup'

require 'web_analytics_discovery'

RSpec.configure { |config|
  # some (optional) config here
}

def full_result_check(res)
  res[:visitors_day].should_not be_nil
  res[:visits_day].should_not be_nil
  res[:pv_day].should_not be_nil

  res[:visitors_week].should_not be_nil
  res[:visits_week].should_not be_nil
  res[:pv_week].should_not be_nil

  res[:visitors_mon].should_not be_nil
  res[:visits_mon].should_not be_nil
  res[:pv_mon].should_not be_nil
end
