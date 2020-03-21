# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'expects to be present' do
    expect(User.new(id: 1, role: :admin)).to be_present
  end

  it 'expects to be blank' do
    expect(User.new(id: nil, role: :admin)).to be_blank
  end

  it 'expects to be admin' do
    expect(User.new(id: 1, role: :admin)).to be_admin
  end

  it 'expects to be recruiter' do
    expect(User.new(id: 1, role: :recruiter)).to be_recruiter
  end

  it 'expects to be evaluator' do
    expect(User.new(id: 1, role: :evaluator)).to be_evaluator
  end
end
