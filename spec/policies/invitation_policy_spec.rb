require 'rails_helper'

describe InvitationPolicy do
  describe '#show?' do
    subject { InvitationPolicy.new(user, record).show? }

    let(:record) { create(:invitation) }

    describe 'user is not related to the the invitation' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    describe 'user is related to the invitation' do
      let(:user) { create(:share, topic: record.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#create?' do
    subject { InvitationPolicy.new(user, record).create? }

    let(:record) { build(:invitation, topic: topic) }

    let(:topic) { create(:topic) }

    describe 'user is not related to the the invitation' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    describe 'user is related to the invitation' do
      let(:user) { create(:share, topic: topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#update?' do
    its(:update?) { is_expected.to eq(false) }
  end

  describe '#destroy?' do
    subject { InvitationPolicy.new(user, record).destroy? }

    let(:record) { create(:invitation) }

    describe 'user is not related to the the invitation' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    describe 'user is related to the invitation' do
      let(:user) { create(:share, topic: record.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#permitted_attributes' do
    its(:permitted_attributes) { is_expected.to match_array(%i(email)) }
  end

  describe '#accessible_attributes' do
    let(:attrs) { %i(id email expired created_at updated_at) }

    its(:accessible_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_associations' do
    its(:accessible_associations) { is_expected.to eq([]) }
  end
end
