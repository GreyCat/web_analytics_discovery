require 'spec_helper'

def check_openstat(res)
  res[:visitors_day].should_not be_nil
  res[:visits_day].should_not be_nil
  res[:pv_day].should_not be_nil

  res[:visitors_mon].should_not be_nil
  res[:visits_mon].should_not be_nil
  res[:pv_mon].should_not be_nil
end

describe Openstat do
  it 'should parse utro.ru' do
    res = Openstat.new.run('http://utro.ru/')
    res[:id].should == 13838
    check_openstat(res)
  end
end
