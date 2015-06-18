require 'rails_helper'

describe Comment do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:comments) }
    it { is_expected.to belong_to(:item).inverse_of(:comments) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:item) }
    it { is_expected.to validate_presence_of(:comment) }
  end
end
