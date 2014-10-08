require 'spec_helper'

describe TNS do
  it 'should parse rbc.ru' do
    res = TNS.new.run('http://rbc.ru/')
    res.should_not be_nil
    res[:id].should == 'rbc.ru'

    res[:visitors_mon].should_not be_nil
    res[:visitors_mon].should be_an(Integer)
  end

  it 'should parse mamba.ru (mangled ID)' do
    res = TNS.new.run('http://mamba.ru/')
    res.should_not be_nil
    res[:id].should == 'mamba.ru'

    res[:visitors_mon].should_not be_nil
    res[:visitors_mon].should be_an(Integer)
  end
end
