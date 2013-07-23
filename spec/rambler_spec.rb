require 'spec_helper'

describe Rambler do
  it 'should parse linux.org.ru' do
    res = Rambler.new.run('http://linux.org.ru/')
    full_result_check(res)
    res[:id].should == 29833
  end
end
