require 'spec_helper'

def check_sanity(res)
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

describe LiveInternet do
  it 'should parse utro.ru' do
    res = LiveInternet.new.run('http://utro.ru/')
    res[:id].should == 'utro.ru'
    check_sanity(res)
  end

  it 'should parse gazeta.ru' do
    res = LiveInternet.new.run('http://gazeta.ru/')
    res[:id].should == 'gazeta_all'
    check_sanity(res)
  end
end
