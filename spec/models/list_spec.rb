require 'rails_helper'

describe List do
  describe 'associations' do
    it { is_expected.to belong_to(:topic).inverse_of(:lists).counter_cache(true) }
    it { is_expected.to have_many(:items).dependent(:destroy).inverse_of(:list) }
    it { is_expected.to have_many(:users).through(:topic) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:topic) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end

  describe '#item_positions=' do
    let!(:items) { create_list(:item, 10, list: list).shuffle }

    let(:list) { create(:list) }

    it 'updates the position attributes of the items' do
      expect {
        list.item_positions = items.map(&:id)
      }.to change {
        list.items.order(position: :asc).pluck(:id)
      }.to(items.map(&:id))
    end
  end
end
