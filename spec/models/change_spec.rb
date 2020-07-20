# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Change, type: :model do
  it do
    is_expected.to(
      belong_to(:user)
        .with_primary_key('email_token')
        .with_foreign_key('user_token')
    )
  end

  it { is_expected.to validate_presence_of(:context) }
end
