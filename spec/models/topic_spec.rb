require 'rails_helper'

describe Topic do
  describe 'associations' do
    it { is_expected.to have_many(:lists).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:invitations).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:shares).dependent(:destroy).inverse_of(:topic) }
    it { is_expected.to have_many(:users).through(:shares) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end

  describe '#list_positions=' do
    let!(:lists) { create_list(:list, 10, topic: topic).shuffle }

    let(:topic) { create(:topic) }

    it 'updates the position attributes of the lists' do
      expect {
        topic.list_positions = lists.map(&:id)
      }.to change {
        topic.lists.order(position: :asc).pluck(:id)
      }.to(lists.map(&:id))
    end
  end

  describe '#dangling?' do
    subject { topic.dangling? }

    let(:topic) { create(:topic) }

    context 'with no shares or invitations' do
      it { is_expected.to eq(true) }
    end

    context 'with a share' do
      before { create(:share, topic: topic) }

      it { is_expected.to eq(false) }

      context 'and an invitation' do
        before { create(:invitation, topic: topic) }

        it { is_expected.to eq(false) }
      end
    end

    context 'with an invitation' do
      before { create(:invitation, topic: topic) }

      it { is_expected.to eq(false) }
    end
  end
end
