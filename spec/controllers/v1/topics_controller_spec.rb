require 'rails_helper'

describe V1::TopicsController do
  describe 'GET #index' do
    let!(:topics) { create_list(:share, 3, user: user).map(&:topic) }

    before { create_list(:topic, 2) }

    before { set_auth_header(token) }

    before { get :index }

    let(:user) { create(:user) }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      it { is_expected.to respond_with(:ok) }

      it 'reponds with the users topics' do
        expect(json[:topics]).to match_array(topics_json(topics))
      end
    end
  end

  describe 'GET #show' do
    before { set_auth_header(token) }

    before { get :show, id: id }

    let(:id) { topic.id }

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

        it 'respond with the topic' do
          expect(json[:topic]).to eq(topic_json(topic))
        end
      end
    end
  end

  describe 'POST #create' do
    before { set_auth_header(token) }

    before { post :create, params }

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
        let(:params) { {topic: {name: name}} }

        let(:name) { build(:topic).name }

        context 'but invalid name' do
          let(:name) { [nil, SecureRandom.hex(128)].sample }

          it { is_expected.to respond_with(:unprocessable_entity) }

          it 'responds with error details' do
            expect(json[:errors][:name]).to be_present
          end
        end

        context 'that are valid' do
          let(:topic) { Topic.find(json[:topic][:id]) }

          it { is_expected.to respond_with(:created) }

          it 'responds with the topic' do
            expect(json[:topic]).to eq(topic_json(topic))
          end

          it 'sets the correct name' do
            expect(topic.name).to eq(name)
          end

          it 'associates the user with the topic' do
            expect(topic.users).to match_array([user])
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    before { set_auth_header(token) }

    before { patch :update, params.merge(id: id) }

    let(:id) { topic.id }

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
          let(:params) { {topic: {name: name}} }

          let(:name) { build(:topic).name }

          context 'but invalid name' do
            let(:name) { [nil, SecureRandom.hex(128)].sample }

            it { is_expected.to respond_with(:unprocessable_entity) }

            it 'responds with error details' do
              expect(json[:errors][:name]).to be_present
            end
          end

          context 'that are valid' do
            it { is_expected.to respond_with(:ok) }

            it 'responds with the updated topic' do
              expect(json[:topic]).to eq(topic_json(topic.reload))
            end

            it 'sets the correct name' do
              expect(topic.reload.name).to eq(name)
            end
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { set_auth_header(token) }

    before { delete :destroy, id: id }

    let(:id) { topic.id }

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

        it { is_expected.to respond_with(:no_content) }

        it 'destroys the topic' do
          expect { topic.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
