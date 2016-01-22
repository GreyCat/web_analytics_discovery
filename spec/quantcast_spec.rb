require 'spec_helper'

describe Quantcast do
  it 'should parse photobucket.com directly' do
    res = Quantcast.new.run('http://photobucket.com/')
    expect(res[:id]).to eq('wd:com.photobucket')

    expect(res[:visitors_day]).not_to be_nil
    expect(res[:visitors_day]).to be_an(Integer)
    expect(res[:visits_day]).not_to be_nil
    expect(res[:visits_day]).to be_an(Integer)
    expect(res[:pv_day]).not_to be_nil
    expect(res[:pv_day]).to be_an(Integer)

    expect(res[:visitors_week]).not_to be_nil
    expect(res[:visitors_week]).to be_an(Integer)
    expect(res[:visits_week]).not_to be_nil
    expect(res[:visits_week]).to be_an(Integer)
    expect(res[:pv_week]).not_to be_nil
    expect(res[:pv_week]).to be_an(Integer)

    expect(res[:visitors_mon]).not_to be_nil
    expect(res[:visitors_mon]).to be_an(Integer)
    expect(res[:visits_mon]).not_to be_nil
    expect(res[:visits_mon]).to be_an(Integer)
    expect(res[:pv_mon]).not_to be_nil
    expect(res[:pv_mon]).to be_an(Integer)

    expect(res[:pv_week].to_f / res[:pv_day]).to be_between(6, 8)
    expect(res[:pv_mon].to_f / res[:pv_day]).to be_between(25, 35)

    expect(res[:visits_week].to_f / res[:visits_day]).to be_between(6, 8)
    expect(res[:visits_mon].to_f / res[:visits_day]).to be_between(25, 35)
  end
  it 'should parse yahoo.com indirectly' do
    res = Quantcast.new.run('http://yahoo.com/')
    expect(res[:id]).to eq('wd:com.yahoo')

    expect(res[:visitors_mon]).not_to be_nil
    expect(res[:visitors_mon]).to be_an(Integer)
  end
end
