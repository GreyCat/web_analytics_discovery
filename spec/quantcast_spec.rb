require 'spec_helper'

def check_mailru(res)
  res[:visitors_day].should_not be_nil
  res[:visitors_day].should be_an(Integer)
  res[:pv_day].should_not be_nil
  res[:pv_day].should be_an(Integer)

  res[:visitors_week].should_not be_nil
  res[:visitors_week].should be_an(Integer)
  res[:pv_week].should_not be_nil
  res[:pv_week].should be_an(Integer)

  res[:visitors_mon].should_not be_nil
  res[:visitors_mon].should be_an(Integer)
  res[:pv_mon].should_not be_nil
  res[:pv_mon].should be_an(Integer)
end

describe Quantcast do
  it 'should parse linkedin.com directly' do
    res = Quantcast.new.run('http://linkedin.com/')
    res[:id].should == 'wd:com.linkedin'

    res[:visitors_day].should_not be_nil
    res[:visitors_day].should be_an(Integer)
    res[:visits_day].should_not be_nil
    res[:visits_day].should be_an(Integer)
    res[:pv_day].should_not be_nil
    res[:pv_day].should be_an(Integer)
    
    res[:visitors_week].should_not be_nil
    res[:visitors_week].should be_an(Integer)
    res[:visits_week].should_not be_nil
    res[:visits_week].should be_an(Integer)
    res[:pv_week].should_not be_nil
    res[:pv_week].should be_an(Integer)
    
    res[:visitors_mon].should_not be_nil
    res[:visitors_mon].should be_an(Integer)
    res[:visits_mon].should_not be_nil
    res[:visits_mon].should be_an(Integer)
    res[:pv_mon].should_not be_nil
    res[:pv_mon].should be_an(Integer)

    (res[:pv_week].to_f / res[:pv_day]).should be_between(6, 8)
    (res[:pv_mon].to_f / res[:pv_day]).should be_between(25, 35)

    (res[:visits_week].to_f / res[:visits_day]).should be_between(6, 8)
    (res[:visits_mon].to_f / res[:visits_day]).should be_between(25, 35)
  end
  it 'should parse yahoo.com indirectly' do
    res = Quantcast.new.run('http://yahoo.com/')
    res[:id].should == 'wd:com.yahoo'

    res[:visitors_mon].should_not be_nil
    res[:visitors_mon].should be_an(Integer)
  end
end
