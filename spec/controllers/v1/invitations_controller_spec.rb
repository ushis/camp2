require 'rails_helper'

describe V1::InvitationsController do
  describe 'GET #index' do
    let!(:invitations) { create_list(:invitation, 3, topic: topic) }

    before { create_list(:invitation, 2) }

    before { set_auth_header(token) }

    before { get :index, topic_id: topic_id }

    let(:topic_id) { topic.id }

    let(:topic) { create(:topic) }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:not_found) }

      context 'who is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        it { is_expected.to respond_with(:ok) }

        it 'responds with the topics invitations' do
          expect(json[:invitations]).to \
            match_array(invitations_json(invitations))
        end
      end
    end
  end

  describe 'GET #show' do
    before { set_auth_header(token) }

    before { get :show, topic_id: topic_id, id: id }

    let(:topic_id) { topic.id }

    let(:topic) { invitation.topic }

    let(:id) { invitation.id }

    let(:invitation) { create(:invitation) }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:not_found) }

      context 'who is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        it { is_expected.to respond_with(:ok) }

        it 'responds with the topics invitations' do
          expect(json[:invitation]).to eq(invitation_json(invitation))
        end
      end
    end
  end

  describe 'POST #create' do
    before { set_auth_header(token) }

    before { post :create, params.merge(topic_id: topic_id) }

    let(:topic_id) { topic.id }

    let(:topic) { create(:topic) }

    let(:params) { {} }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:not_found) }

      context 'who is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        context 'without params' do
          it { is_expected.to respond_with(:unprocessable_entity) }
        end

        context 'with params' do
          let(:params) { {invitation: {email: email}} }

          let(:email) { build(:invitation).email }

          context 'but invalid email' do
            let(:email) { [nil, 'www.example.com'].sample }

            it { is_expected.to respond_with(:unprocessable_entity) }

            it 'responds with error details' do
              expect(json[:errors][:email]).to be_present
            end
          end

          context 'that are valid' do
            let(:invitation) { Invitation.find(json[:invitation][:id]) }

            it { is_expected.to respond_with(:created) }

            it 'responds with the invitation' do
              expect(json[:invitation]).to eq(invitation_json(invitation))
            end

            it 'sets the correct email' do
              expect(invitation.email).to eq(email)
            end

            it 'connects the invitation with the topic' do
              expect(invitation.topic).to eq(topic)
            end
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { set_auth_header(token) }

    before { delete :destroy, topic_id: topic_id, id: id }

    let(:topic_id) { topic.id }

    let(:topic) { invitation.topic }

    let(:id) { invitation.id }

    let(:invitation) { create(:invitation) }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:not_found) }

      context 'who is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        context 'with invalid id' do
          let(:id) { create(:invitation).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid id' do
          it { is_expected.to respond_with(:no_content) }

          it 'destroys the invitation' do
            expect { invitation.reload }.to \
              raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
