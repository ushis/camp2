require 'rails_helper'

describe V1::SessionsController do
  describe 'POST #create' do
    before { post :create, params }

    context 'without params' do
      let(:params) { {} }

      it { is_expected.to respond_with(:unprocessable_entity) }
    end

    context 'with params' do
      let(:params) do
        {
          user: {
            email: email,
            password: password
          }
        }
      end

      let(:email) { user.email }

      let(:password) { user.password }

      let(:user) { create(:user) }

      context 'but invalid email' do
        let(:email) { 'test@example.com' }

        it { is_expected.to respond_with(:unauthorized) }

        context 'and invalid password' do
          let(:password) { 'secret' }

          it { is_expected.to respond_with(:unauthorized) }
        end
      end

      context 'but invalid password' do
        let(:password) { 'secret' }

        it { is_expected.to respond_with(:unauthorized) }
      end

      context 'that are valid credentials' do
        it { is_expected.to respond_with(:created) }

        it 'responds with session json' do
          expect(json[:user]).to eq(session_json(user))
        end
      end
    end
  end
end
