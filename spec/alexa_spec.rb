require 'spec_helper'

describe Alexa do
  it 'should parse utro.ru' do
    res = Alexa.new.run('http://utro.ru/')
    res[:id].should == 'utro.ru'

    res[:pv_day].should_not be_nil
    res[:visitors_mon].should_not be_nil
    res[:pv_mon].should_not be_nil
  end

  it 'should parse dealfish.co.th directly' do
    res = Alexa.new.run('http://dealfish.co.th/')
    res[:id].should == 'dealfish.co.th'

    res[:visitors_day].should_not be_nil
    res[:pv_day].should_not be_nil
    res[:visitors_mon].should_not be_nil
    res[:pv_mon].should_not be_nil
  end
end
