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

describe MailRu do
  it 'should parse bash.im' do
    res = MailRu.new.run('http://bash.im/')
    res[:id].should == 901403
    check_mailru(res)
  end
  it 'should parse lady.mail.ru' do
    res = MailRu.new.run('http://lady.mail.ru/')
    res[:id].should == 1018953
    check_mailru(res)
  end
  it 'should parse lib.ru' do
    res = MailRu.new.run('http://lib.ru/')
    res[:id].should == 105282
    check_mailru(res)
  end
end
