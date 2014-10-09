require 'spec_helper'

def check_mailru(res)
  expect(res[:visitors_day]).not_to be_nil
  expect(res[:visitors_day]).to be_an(Integer)
  expect(res[:pv_day]).not_to be_nil
  expect(res[:pv_day]).to be_an(Integer)

  expect(res[:visitors_week]).not_to be_nil
  expect(res[:visitors_week]).to be_an(Integer)
  expect(res[:pv_week]).not_to be_nil
  expect(res[:pv_week]).to be_an(Integer)

  expect(res[:visitors_mon]).not_to be_nil
  expect(res[:visitors_mon]).to be_an(Integer)
  expect(res[:pv_mon]).not_to be_nil
  expect(res[:pv_mon]).to be_an(Integer)
end

describe MailRu do
  it 'should parse bash.im' do
    res = MailRu.new.run('http://bash.im/')
    expect(res[:id]).to eq(901403)
    check_mailru(res)
  end
  it 'should parse lady.mail.ru' do
    res = MailRu.new.run('http://lady.mail.ru/')
    expect(res[:id]).to eq(1018953)
    check_mailru(res)
  end
  it 'should parse lib.ru' do
    res = MailRu.new.run('http://lib.ru/')
    expect(res[:id]).to eq(105282)
    check_mailru(res)
  end
end
