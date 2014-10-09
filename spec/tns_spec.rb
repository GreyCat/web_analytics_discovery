require 'spec_helper'

describe TNS do
  it 'should parse rbc.ru' do
    res = TNS.new.run('http://rbc.ru/')
    expect(res).not_to be_nil
    expect(res[:id]).to eq('rbc.ru')

    expect(res[:visitors_mon]).not_to be_nil
    expect(res[:visitors_mon]).to be_an(Integer)
  end

  it 'should parse mamba.ru (mangled ID)' do
    res = TNS.new.run('http://mamba.ru/')
    expect(res).not_to be_nil
    expect(res[:id]).to eq('mamba.ru')

    expect(res[:visitors_mon]).not_to be_nil
    expect(res[:visitors_mon]).to be_an(Integer)
  end
end
