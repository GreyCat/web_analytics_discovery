require 'spec_helper'

describe Alexa do
  it 'should parse alexa.com with certified metrics' do
    res = Alexa.new.run('http://alexa.com/')
    res[:id].should == 'alexa.com'

    res[:visitors_day].should_not be_nil
    res[:pv_day].should_not be_nil
    res[:visitors_mon].should_not be_nil
    res[:pv_mon].should_not be_nil
  end
end
