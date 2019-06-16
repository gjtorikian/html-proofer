# frozen_string_literal: true

require 'spec_helper'

describe 'Maliciousness test' do
  it 'does not accept non-string input for single file' do
    expect do
      run_proofer(23, :file)
    end.to raise_error ArgumentError
  end

  it 'does not accept non-string input for directory' do
    expect do
      run_proofer(['wow/wow'], :directory)
    end.to raise_error ArgumentError
  end

  it 'does not accept string input for directories' do
    expect do
      run_proofer('wow/wow', :directories)
    end.to raise_error ArgumentError
  end

  it 'does not accept string input for links' do
    expect do
      run_proofer('woo', :links)
    end.to raise_error ArgumentError
  end
end
