require 'rails_helper'

describe TopicPolicy do
  describe '#show?' do
    subject { TopicPolicy.new(user, record).show? }

    let(:record) { create(:topic) }

    context 'user is not related to the topic' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is releated to the topic' do
      let(:user) { create(:share, topic: record).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#create?' do
    its(:create?) { is_expected.to eq(true) }
  end

  describe '#update?' do
    subject { TopicPolicy.new(user, record).update? }

    let(:record) { create(:topic) }

    context 'user is not related to the topic' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is releated to the topic' do
      let(:user) { create(:share, topic: record).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#destroy?' do
    subject { TopicPolicy.new(user, record).destroy? }

    let(:record) { create(:topic) }

    context 'user is not related to the topic' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is releated to the topic' do
      let(:user) { create(:share, topic: record).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#permitted_attributes' do
    let(:attrs) { [:name, list_positions: []] }

    its(:permitted_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_attributes' do
    let(:attrs) do
      %i(
          id name
          shares_count invitations_count lists_count
          created_at updated_at
      )
    end

    its(:accessible_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_associations' do
    its(:accessible_associations) { is_expected.to eq([]) }
  end
end
