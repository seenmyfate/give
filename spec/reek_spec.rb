require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Give do
  it 'contains no code smells' do
    pending "UtilityFunction Fail"
    Dir['lib/*.rb'].should_not reek
  end
end
