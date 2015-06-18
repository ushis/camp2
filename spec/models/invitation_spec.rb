require 'rails_helper'

describe Invitation do
  describe 'associations' do
    it { is_expected.to belong_to(:topic).inverse_of(:invitations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it { is_expected.to allow_value('test+somthing@example.com').for(:email) }
    it { is_expected.to_not allow_value('@gmail.com').for(:email) }

    describe 'uniqueness validations' do
      before { create(:invitation) }

      it { is_expected.to validate_uniqueness_of(:email).scoped_to(:topic_id) }
    end
  end

  describe 'after_destroy callbacks' do
    let(:invitation) { create(:invitation) }

    let(:topic) { invitation.topic }

    context 'when the topic has no other invitations' do
      it 'destroys the topic' do
        expect {
          invitation.destroy
        }.to change {
          Topic.find_by(id: topic.id)
        }.from(topic).to(nil)
      end
    end

    context 'when the topic has another invitation' do
      before { create(:invitation, topic: topic) }

      it 'does nothing' do
        expect {
          invitation.destroy
        }.to_not change {
          Topic.find_by(id: topic.id)
        }
      end
    end

    context 'when the topic has a share' do
      before { create(:share, topic: topic) }

      it 'does nothing' do
        expect {
          invitation.destroy
        }.to_not change {
          Topic.find_by(id: topic.id)
        }
      end
    end
  end

  describe '.active' do
    let!(:expired1) { create(:invitation, created_at: 6.weeks.ago) }

    let!(:expired2) { create(:invitation, created_at: 5.weeks.ago) }

    let!(:active1) { create(:invitation, created_at: 3.weeks.ago) }

    let!(:active2) { create(:invitation, created_at: 1.week.ago) }

    subject { Invitation.active }

    it { is_expected.to match_array([active1, active2]) }
  end

  describe '.expired' do
    let!(:expired1) { create(:invitation, created_at: 6.weeks.ago) }

    let!(:expired2) { create(:invitation, created_at: 5.weeks.ago) }

    let!(:active1) { create(:invitation, created_at: 3.weeks.ago) }

    let!(:active2) { create(:invitation, created_at: 1.week.ago) }

    subject { Invitation.expired }

    it { is_expected.to match_array([expired1, expired2]) }
  end

  describe '.find_by_invitation_token' do
    subject { Invitation.find_by_invitation_token(token) }

    let(:token) { Token.new(id, scope, exp).to_s }

    let(:invitation) { create(:invitation) }

    let(:id) { invitation.id }

    let(:scope) { :invitation }

    let(:exp) { 1.week.from_now.to_i }

    it { is_expected.to eq(invitation) }

    context 'given a token with invalid id' do
      let(:id) { -1 }

      it { is_expected.to eq(nil) }
    end

    context 'given a token with invalid scope' do
      let(:scope) { :invalid }

      it { is_expected.to eq(nil) }
    end

    context 'given an expired token' do
      let(:exp) { 1.minute.ago.to_i }

      it { is_expected.to eq(nil) }
    end
  end

  describe '.find_by_invitation_token!' do
    subject { Invitation.find_by_invitation_token!(token) }

    let(:invitation) { create(:invitation) }

    let(:token) { Token.new(id, scope, exp).to_s }

    let(:id) { invitation.id }

    let(:scope) { :invitation }

    let(:exp) { 1.week.from_now.to_i }

    it { is_expected.to eq(invitation) }

    context 'given a token with invalid id' do
      let(:id) { -1 }

      it 'raises an error' do
        expect { Invitation.find_by_invitation_token!(token) }.to \
          raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'given a token with invalid scope' do
      let(:scope) { :invalid }

      it 'raises an error' do
        expect { Invitation.find_by_invitation_token!(token) }.to \
          raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'given an expired token' do
      let(:exp) { 1.minute.ago.to_i }

      it 'raises an error' do
        expect { Invitation.find_by_invitation_token!(token) }.to \
          raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#invitation_token' do
    subject { Invitation.tokens[:invitation].from_s(token) }

    let(:token) { invitation.invitation_token }

    let(:invitation) { create(:invitation) }

    its(:id) { is_expected.to eq(invitation.id) }

    its(:scope) { is_expected.to eq('invitation') }

    its(:exp) { is_expected.to eq(4.weeks.from_now.to_i) }
  end

  describe '#active?' do
    subject { invitation.active? }

    let(:invitation) { build(:invitation, created_at: created_at) }

    context 'when the invitation is older than 4 weeks' do
      let(:created_at) { 5.weeks.ago }

      it { is_expected.to eq(false) }
    end

    context 'when the invitation is younger than 4 weeks' do
      let(:created_at) { 3.weeks.ago }

      it { is_expected.to eq(true) }
    end
  end

  describe '#expired?' do
    subject { invitation.expired? }

    let(:invitation) { build(:invitation, created_at: created_at) }

    context 'when the invitation is older than 4 weeks' do
      let(:created_at) { 5.weeks.ago }

      it { is_expected.to eq(true) }
    end

    context 'when the invitation is younger than 4 weeks' do
      let(:created_at) { 3.weeks.ago }

      it { is_expected.to eq(false) }
    end
  end

  describe '#build_share_for' do
    subject { invitation.build_share_for(user) }

    let(:user) { build(:user) }

    let(:invitation) { build(:invitation) }

    it { is_expected.to be_a(Share) }

    its(:user) { is_expected.to eq(user) }

    its(:topic) { is_expected.to eq(invitation.topic) }

    its(:invitation) { is_expected.to eq(invitation) }
  end
end
