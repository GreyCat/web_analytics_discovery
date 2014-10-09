require 'spec_helper'

describe LiveInternet do
  it 'should parse utro.ru' do
    res = LiveInternet.new.run('http://utro.ru/')
    expect(res[:id]).to eq('utro.ru')
    full_result_check(res)
  end

  it 'should parse gazeta.ru' do
    res = LiveInternet.new.run('http://gazeta.ru/')
    expect(res[:id]).to eq('gazeta_all')
    full_result_check(res)
  end
end
