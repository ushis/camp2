require 'rails_helper'

describe Item do
  describe 'associations' do
    it { is_expected.to belong_to(:list).inverse_of(:items).counter_cache(true) }
    it { is_expected.to have_many(:comments).dependent(:destroy).inverse_of(:item) }
    it { is_expected.to have_many(:users).through(:list) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:list) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }

    describe 'list_id' do
      subject { item }

      before { item.list = other_list }

      let(:item) { create(:item) }

      context 'other list is the current list' do
        let(:other_list) { item.list }

        it { is_expected.to be_valid }
      end

      context 'other list is of the same topic' do
        let(:other_list) { create(:list, topic: item.list.topic) }

        it { is_expected.to be_valid }
      end

      context 'other list is of another topic' do
        let(:other_list) { create(:list) }

        it { is_expected.to_not be_valid }
      end
    end
  end
end
