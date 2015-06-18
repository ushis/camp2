require 'rails_helper'

describe Item do
  describe 'associations' do
    it { is_expected.to belong_to(:list).inverse_of(:items) }
    it { is_expected.to have_many(:comments).dependent(:destroy).inverse_of(:item) }
    it { is_expected.to have_many(:users).through(:list) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:list) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end
end
