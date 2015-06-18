require 'rails_helper'

describe ItemPolicy do
  describe '#show?' do
    subject { ItemPolicy.new(user, record).show? }

    let(:record) { create(:item) }

    context 'user is not related to the item' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the item' do
      let(:user) { create(:share, topic: record.list.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#create?' do
    subject { ItemPolicy.new(user, record).create? }

    let(:record) { build(:item, list: list) }

    let(:list) { create(:list) }

    context 'user is not related to the item' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the item' do
      let(:user) { create(:share, topic: list.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#update?' do
    subject { ItemPolicy.new(user, record).update? }

    let(:record) { create(:item) }

    context 'user is not related to the item' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the item' do
      let(:user) { create(:share, topic: record.list.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#destroy?' do
    subject { ItemPolicy.new(user, record).destroy? }

    let(:record) { create(:item) }

    context 'user is not related to the item' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the item' do
      let(:user) { create(:share, topic: record.list.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#permitted_attributes' do
    its(:permitted_attributes) { is_expected.to match_array(%i(name)) }
  end

  describe '#accessible_attributes' do
    let(:attrs) { %i(id name created_at updated_at) }

    its(:accessible_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_associations' do
    its(:accessible_associations) { is_expected.to eq([]) }
  end
end
