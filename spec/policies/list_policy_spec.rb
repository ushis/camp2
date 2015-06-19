require 'rails_helper'

describe ListPolicy do
  describe '#show?' do
    subject { ListPolicy.new(user, record).show? }

    let(:record) { create(:list) }

    context 'user is not related to the list' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the list' do
      let(:user) { create(:share, topic: record.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#create?' do
    subject { ListPolicy.new(user, record).create? }

    let(:record) { build(:list, topic: topic) }

    let(:topic) { create(:topic) }

    context 'user is not related to the list' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the list' do
      let(:user) { create(:share, topic: topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#update?' do
    subject { ListPolicy.new(user, record).update? }

    let(:record) { create(:list) }

    context 'user is not related to the list' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the list' do
      let(:user) { create(:share, topic: record.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#destroy?' do
    subject { ListPolicy.new(user, record).destroy? }

    let(:record) { create(:list) }

    context 'user is not related to the list' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the list' do
      let(:user) { create(:share, topic: record.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#permitted_attributes' do
    let(:attrs) { [:name, item_positions: []] }

    its(:permitted_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_attributes' do
    let(:attrs) { %i(id name items_count created_at updated_at) }

    its(:accessible_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_associations' do
    its(:accessible_associations) { is_expected.to eq([]) }
  end
end
