require 'rails_helper'

describe Share do
  describe 'assocations' do
    it { is_expected.to belong_to(:user).inverse_of(:shares) }
    it { is_expected.to belong_to(:topic).inverse_of(:shares) }
  end

  describe 'assocations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:topic) }

    describe 'uniqueness validations' do
      before { create(:share) }

      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:topic_id) }
    end
  end

  describe 'after_create callbacks' do
    let(:share) { build(:share, invitation: invitation) }

    context 'when it has an invitation' do
      let(:invitation) { create(:invitation) }

      it 'destroys the invitation' do
        expect {
          share.save
        }.to change {
          Invitation.find_by(id: invitation.id)
        }.from(invitation).to(nil)
      end
    end

    context 'when it does not have an invitation' do
      let(:invitation) { nil }

      it 'does nothing' do
        expect { share.save }.to_not change { Invitation.count }
      end
    end
  end

  describe 'after_destroy callbacks' do
    let(:share) { create(:share) }

    let(:topic) { share.topic }

    context 'when the topic has no other shares' do
      it 'destroys the topic' do
        expect {
          share.destroy
        }.to change {
          Topic.find_by(id: topic.id)
        }.from(topic).to(nil)
      end
    end

    context 'when the topic has another share' do
      before { create(:share, topic: topic) }

      it 'does nothing' do
        expect { share.destroy }.to_not change { Topic.find_by(id: topic.id) }
      end
    end

    context 'when the topic has an invitation' do
      before { create(:invitation, topic: topic) }

      it 'does nothing' do
        expect { share.destroy }.to_not change { Topic.find_by(id: topic.id) }
      end
    end
  end
end
