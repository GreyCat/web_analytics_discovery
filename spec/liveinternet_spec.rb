require 'spec_helper'

describe LiveInternet do
  it 'should parse utro.ru' do
    res = LiveInternet.new.run('http://utro.ru/')
    res[:id].should == 'utro.ru'
    full_result_check(res)
  end

  it 'should parse gazeta.ru' do
    res = LiveInternet.new.run('http://gazeta.ru/')
    res[:id].should == 'gazeta_all'
    full_result_check(res)
  end
end
