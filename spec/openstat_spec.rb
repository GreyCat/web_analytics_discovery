require 'spec_helper'

def check_openstat(res)
  expect(res[:visitors_day]).not_to be_nil
  expect(res[:visits_day]).not_to be_nil
  expect(res[:pv_day]).not_to be_nil

  expect(res[:visitors_mon]).not_to be_nil
  expect(res[:visits_mon]).not_to be_nil
  expect(res[:pv_mon]).not_to be_nil
end

describe Openstat do
  it 'should parse utro.ru' do
    res = Openstat.new.run('http://utro.ru/')
    expect(res[:id]).to eq(13838)
    check_openstat(res)
  end
  it 'should parse lib.ru' do
    res = Openstat.new.run('http://lib.ru/')
    expect(res[:id]).to eq(8369)
    check_openstat(res)
  end
end
