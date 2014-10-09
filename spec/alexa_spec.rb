require 'spec_helper'

describe Alexa do
  it 'should parse alexa.com with certified metrics' do
    res = Alexa.new.run('http://alexa.com/')
    expect(res[:id]).to eq('alexa.com')

    expect(res[:visitors_day]).not_to be_nil
    expect(res[:pv_day]).not_to be_nil
    expect(res[:visitors_mon]).not_to be_nil
    expect(res[:pv_mon]).not_to be_nil
  end
end
