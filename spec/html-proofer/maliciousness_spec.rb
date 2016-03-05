require 'spec_helper'

describe 'Maliciousness test' do

  it 'does not accept non-string input for single file' do
    expect {
      run_proofer(23, :file)
    }.to raise_error ArgumentError
  end

  it 'does not accept non-string input for directory' do
    expect {
      run_proofer(['wow/wow'], :directory)
    }.to raise_error ArgumentError
  end

  it 'does not accept string input for directories' do
    expect {
      run_proofer('wow/wow', :directories)
    }.to raise_error ArgumentError
  end

  it 'does not accept string input for links' do
    expect {
      run_proofer('woo', :links)
    }.to raise_error ArgumentError
  end
end
