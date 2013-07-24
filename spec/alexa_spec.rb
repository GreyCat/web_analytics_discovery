require 'spec_helper'

describe Alexa do
  it 'should parse utro.ru' do
    res = Alexa.new.run('http://utro.ru/')
    res[:id].should == 'utro.ru'

    res[:pv_day].should_not be_nil
    res[:visitors_mon].should_not be_nil
    res[:pv_mon].should_not be_nil
  end
end
