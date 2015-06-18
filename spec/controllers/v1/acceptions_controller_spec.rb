require 'rails_helper'

describe V1::AcceptionsController do
  describe 'POST #create' do
    let!(:invitation) { create(:invitation, created_at: created_at) }

    before { set_auth_header(token) }

    before { post :create, params }

    let(:created_at) { Time.zone.now }

    let(:params) { {} }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      context 'without params' do
        it { is_expected.to respond_with(:unprocessable_entity) }
      end

      context 'with params' do
        let(:params) { {acception: {invitation_token: invitation_token}} }

        let(:invitation_token) { invitation.invitation_token }

        context 'but invalid invitation token' do
          let(:invitation_token) do
            [nil, "#{invitation.invitation_token}x"].sample
          end

          it { is_expected.to respond_with(:forbidden) }
        end

        context 'but expired invitation token' do
          let(:created_at) { 5.weeks.ago }

          it { is_expected.to respond_with(:forbidden) }
        end

        context 'that are valid' do
          let(:acception) { Share.find(json[:acception][:id]) }

          it { is_expected.to respond_with(:created) }

          it 'responds with the acception' do
            expect(json[:acception]).to eq(acception_json(acception))
          end

          it 'connects the user with the topic' do
            expect(invitation.topic.users).to eq([user])
          end

          it 'destroys the invitation' do
            expect { invitation.reload }.to \
              raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
