require 'spec_helper'

describe TNS do
  it 'should give correct URL for 2012-07' do
    TNS.url_for_report(Date.new(2012, 7)).should == 'http://www.tns-global.ru/media/content/B7525726-B5E1-4C12-BE25-4C543F42F3EE/!Web%20Index%20Report%20201207.zip'
  end

  it 'should parse rbc.ru' do
    res = TNS.new.run('http://rbc.ru/')
    res[:id].should == 'rbc.ru'

    res[:visitors_mon].should_not be_nil
    res[:visitors_mon].should be_an(Integer)
  end
end
