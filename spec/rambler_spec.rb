require 'spec_helper'

describe Rambler do
  it 'should properly find yesterday' do
    Rambler.new.spec_yesterday(Time.new(2013, 7, 13)).should == '12.07.2013'
    Rambler.new.spec_yesterday(Time.new(2013, 1, 1)).should == '31.12.2012'
    Rambler.new.spec_yesterday(Time.new(2012, 3, 1)).should == '29.02.2012'
  end
  it 'should properly find last week' do
    Rambler.new.spec_last_week(Time.new(2013, 7, 13)).should == '01.07.2013+-+07.07.2013'
    Rambler.new.spec_last_week(Time.new(2013, 7, 14)).should == '01.07.2013+-+07.07.2013'
    Rambler.new.spec_last_week(Time.new(2013, 7, 15)).should == '08.07.2013+-+14.07.2013'
    Rambler.new.spec_last_week(Time.new(2013, 7, 16)).should == '08.07.2013+-+14.07.2013'
    Rambler.new.spec_last_week(Time.new(2013, 7, 16)).should == '08.07.2013+-+14.07.2013'
  end
  it 'should properly find last month' do
    Rambler.new.spec_last_month(Time.new(2013, 7, 13)).should == '01.06.2013+-+30.06.2013'
    Rambler.new.spec_last_month(Time.new(2013, 7, 1)).should == '01.06.2013+-+30.06.2013'
    Rambler.new.spec_last_month(Time.new(2013, 7, 2)).should == '01.06.2013+-+30.06.2013'
    Rambler.new.spec_last_month(Time.new(2013, 6, 30)).should == '01.05.2013+-+31.05.2013'
    Rambler.new.spec_last_month(Time.new(2013, 6, 1)).should == '01.05.2013+-+31.05.2013'
    Rambler.new.spec_last_month(Time.new(2013, 5, 31)).should == '01.04.2013+-+30.04.2013'
    Rambler.new.spec_last_month(Time.new(2012, 3, 3)).should == '01.02.2012+-+29.02.2012'
  end
  it 'should parse linux.org.ru' do
    res = Rambler.new.run('http://linux.org.ru/')
    full_result_check(res)
    res[:id].should == 29833
  end
  it 'should parse sport.ru' do
    # Hidden statistics site, information is available only from rating, no session info available
    res = Rambler.new.run('http://sport.ru/')

    res.should_not be_nil

    res[:id].should == 327694

    res[:visitors_day].should_not be_nil
    res[:pv_day].should_not be_nil

    res[:visitors_week].should_not be_nil
    res[:pv_week].should_not be_nil

    res[:visitors_mon].should_not be_nil
    res[:pv_mon].should_not be_nil
  end
end
