require 'spec_helper'

describe Rambler do
  it 'should properly find yesterday' do
    expect(Rambler.new.spec_yesterday(Time.new(2013, 7, 13))).to eq('12.07.2013')
    expect(Rambler.new.spec_yesterday(Time.new(2013, 1, 1))).to eq('31.12.2012')
    expect(Rambler.new.spec_yesterday(Time.new(2012, 3, 1))).to eq('29.02.2012')
  end
  it 'should properly find last week' do
    expect(Rambler.new.spec_last_week(Time.new(2013, 7, 13))).to eq('01.07.2013+-+07.07.2013')
    expect(Rambler.new.spec_last_week(Time.new(2013, 7, 14))).to eq('01.07.2013+-+07.07.2013')
    expect(Rambler.new.spec_last_week(Time.new(2013, 7, 15))).to eq('08.07.2013+-+14.07.2013')
    expect(Rambler.new.spec_last_week(Time.new(2013, 7, 16))).to eq('08.07.2013+-+14.07.2013')
    expect(Rambler.new.spec_last_week(Time.new(2013, 7, 16))).to eq('08.07.2013+-+14.07.2013')
  end
  it 'should properly find last month' do
    expect(Rambler.new.spec_last_month(Time.new(2013, 7, 13))).to eq('01.06.2013+-+30.06.2013')
    expect(Rambler.new.spec_last_month(Time.new(2013, 7, 1))).to eq('01.06.2013+-+30.06.2013')
    expect(Rambler.new.spec_last_month(Time.new(2013, 7, 2))).to eq('01.06.2013+-+30.06.2013')
    expect(Rambler.new.spec_last_month(Time.new(2013, 6, 30))).to eq('01.05.2013+-+31.05.2013')
    expect(Rambler.new.spec_last_month(Time.new(2013, 6, 1))).to eq('01.05.2013+-+31.05.2013')
    expect(Rambler.new.spec_last_month(Time.new(2013, 5, 31))).to eq('01.04.2013+-+30.04.2013')
    expect(Rambler.new.spec_last_month(Time.new(2012, 3, 3))).to eq('01.02.2012+-+29.02.2012')
  end
  it 'should parse livejournal.com' do
    res = Rambler.new.run('http://www.livejournal.com/')
    full_result_check(res)
    expect(res[:id]).to eq(1111412)
  end
  it 'should parse sport.ru' do
    # Hidden statistics site, information is available only from rating, no session info available
    res = Rambler.new.run('http://sport.ru/')

    expect(res).not_to be_nil

    expect(res[:id]).to eq(327694)

    expect(res[:visitors_day]).not_to be_nil
    expect(res[:pv_day]).not_to be_nil

    expect(res[:visitors_week]).not_to be_nil
    expect(res[:pv_week]).not_to be_nil

    expect(res[:visitors_mon]).not_to be_nil
    expect(res[:pv_mon]).not_to be_nil
  end
  it 'should parse ridus.ru' do
    res = Rambler.new.run('http://ridus.ru/')

    expect(res).not_to be_nil

    expect(res[:id]).to eq(2564083)

    expect(res[:visitors_day]).not_to be_nil
    expect(res[:pv_day]).not_to be_nil

    expect(res[:visitors_week]).not_to be_nil
    expect(res[:pv_week]).not_to be_nil

    expect(res[:visitors_mon]).not_to be_nil
    expect(res[:pv_mon]).not_to be_nil
  end
end
