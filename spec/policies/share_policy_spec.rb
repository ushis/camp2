require 'rails_helper'

describe SharePolicy do
  describe '#show?' do
    subject { SharePolicy.new(user, record).show? }

    let(:record) { create(:share) }

    context 'user is not related to the topic' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the topic' do
      let(:user) { create(:share, topic: record.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#create?' do
    subject { SharePolicy.new(user, record).create? }

    let(:user) { create(:user) }

    context 'record has no invitation' do
      let(:record) { build(:share, user: user) }

      it { is_expected.to eq(false) }
    end

    context 'record has an invitation' do
      let(:record) do
        build(:share, user: invitee, invitation: invitation, topic: topic)
      end

      let(:topic) { create(:topic) }

      let(:invitation) { create(:invitation) }

      let(:invitee) { user }

      it { is_expected.to eq(false) }

      context 'for the same topic' do
        let(:topic) { invitation.topic }

        it { is_expected.to eq(true) }

        context 'but the invitation is expired' do
          let(:invitation) { create(:invitation, created_at: 5.weeks.ago) }

          it { is_expected.to eq(false) }
        end

        context 'but the user is another one' do
          let(:invitee) { create(:user) }

          it { is_expected.to eq(false) }
        end
      end
    end
  end

  describe '#update?' do
    its(:update?) { is_expected.to eq(false) }
  end

  describe '#destroy?' do
    subject { SharePolicy.new(user, record).destroy? }

    let(:record) { create(:share) }

    context 'user is not related to the topic' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is related to the topic' do
      let(:user) { create(:share, topic: record.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#permitted_attributes' do
    its(:permitted_attributes) { is_expected.to eq([]) }
  end

  describe '#accessible_attributes' do
    let(:attrs) { %i(id created_at updated_at) }

    its(:accessible_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_associations' do
    let(:assocs) { %i(user topic) }

    its(:accessible_associations) { is_expected.to match_array(assocs) }
  end
end
