# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Change, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:context) }

    it { is_expected.to validate_presence_of(:to) }
  end
end
