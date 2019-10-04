require 'spec_helper'
describe 'tzdata_java' do

  context 'with defaults for all parameters' do
    it { should contain_class('tzdata_java') }
  end
end
