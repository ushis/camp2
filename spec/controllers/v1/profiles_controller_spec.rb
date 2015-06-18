require 'rails_helper'

describe V1::ProfilesController do
  describe 'GET #show' do
    before { set_auth_header(token) }

    before { get :show }

    let(:token) { nil }

    context 'as visitor' do
      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:ok) }

      it 'responds wit the users profile' do
        expect(json[:user]).to eq(profile_json(user))
      end
    end
  end

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
            name: name,
            email: email,
            password: password,
            password_confirmation: password_confirmation
          }
        }
      end

      let(:name) { build(:user).name }

      let(:email) { build(:user).email }

      let(:password) { build(:user).password }

      let(:password_confirmation) { password }

      context 'but invalid name' do
        let(:name) { ['', SecureRandom.hex(128)].sample }

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'responds with error details' do
          expect(json[:errors][:name]).to be_present
        end
      end

      context 'but invalid email' do
        let(:email) { ['', 'www.example.com'].sample }

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'responds with error details' do
          expect(json[:errors][:email]).to be_present
        end
      end

      context 'but without password' do
        let(:password) { nil }

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'responds with error details' do
          expect(json[:errors][:password]).to be_present
        end
      end

      context 'but invalid password_confirmation' do
        let(:password_confirmation) { [nil, 'secret'].sample }

        it { is_expected.to respond_with(:unprocessable_entity) }

        it 'responds with error details' do
          expect(json[:errors][:password_confirmation]).to be_present
        end
      end

      context 'that are valid' do
        let(:user) { User.find(json[:user][:id]) }

        it { is_expected.to respond_with(:created) }

        it 'responds with the new profile' do
          expect(json[:user]).to eq(profile_json(user))
        end

        it 'sets the correct name' do
          expect(user.name).to eq(name)
        end

        it 'sets the correct email' do
          expect(user.email).to eq(email)
        end

        it 'set the correct password' do
          expect(user.authenticate(password)).to eq(user)
        end
      end
    end
  end

  describe 'PATCH #update' do
    before { set_auth_header(token) }

    before { patch :update, params }

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
        let(:params) do
          {
            user: {
              name: name,
              email: email,
              password: password,
              password_confirmation: password_confirmation,
              password_current: password_current
            }
          }
        end

        let(:name) { build(:user).name }

        let(:email) { build(:user).email }

        let(:password) { build(:user).password }

        let(:password_confirmation) { password }

        let(:password_current) { user.password }

        context 'with invalid name' do
          let(:name) { SecureRandom.hex(128) }

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'responds with error details' do
            expect(json[:errors][:name]).to be_present
          end
        end

        context 'with invalid email' do
          let(:email) { 'www.example.com' }

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'responds with error details' do
            expect(json[:errors][:email]).to be_present
          end
        end

        context 'with invalid password/confirmation pair' do
          let(:password_confirmation) { 'secret' }

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'responds with error details' do
            expect(json[:errors][:password_confirmation]).to be_present
          end
        end

        context 'but invalid current password' do
          let(:password_current) { 'secret' }

          it { is_expected.to respond_with(:unauthorized) }
        end

        context 'with valid params' do
          it { is_expected.to respond_with(:ok) }

          it 'responds with the users updated profile' do
            expect(json[:user]).to eq(profile_json(user.reload))
          end

          it 'sets the correct name' do
            expect(user.reload.name).to eq(name)
          end

          it 'sets the correct email' do
            expect(user.reload.email).to eq(email)
          end

          it 'set the correct password' do
            expect(user.reload.authenticate(password)).to eq(user)
          end
        end
      end
    end
  end

  describe 'DElETE #destroy' do
    before { set_auth_header(token) }

    before { delete :destroy, params }

    let(:params) { nil }

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
        let(:params) { {user: {password_current: password}} }

        context 'but invalid password' do
          let(:password) { 'secret' }

          it { is_expected.to respond_with(:unauthorized) }
        end

        context 'and valid password' do
          let(:password) { user.password }

          it { is_expected.to respond_with(:no_content) }

          it 'destroys the user' do
            expect { user.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
