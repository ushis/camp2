require 'rails_helper'

describe V1::SharesController do
  describe 'GET #index' do
    let!(:shares) { create_list(:share, 3, topic: topic) }

    before { create_list(:share, 2) }

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
        let(:user) { shares.sample.user }

        it { is_expected.to respond_with(:ok) }

        it 'responds with the topics shares' do
          expect(json[:shares]).to match_array(shares_json(shares))
        end
      end
    end
  end

  describe 'GET #show' do
    before { set_auth_header(token) }

    before { get :show, topic_id: topic_id, id: id }

    let(:topic_id) { topic.id }

    let(:topic) { share.topic }

    let(:id) { share.id }

    let(:share) { create(:share) }

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
          let(:id) { create(:share).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid id' do
          it { is_expected.to respond_with(:ok) }

          it 'responds with the share' do
            expect(json[:share]).to eq(share_json(share))
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { set_auth_header(token) }

    before { delete :destroy, topic_id: topic_id, id: id }

    let(:topic_id) { topic.id }

    let(:topic) { share.topic }

    let(:id) { share.id }

    let(:share) { create(:share) }

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
          let(:id) { create(:share).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid id' do
          it { is_expected.to respond_with(:no_content) }

          it 'destroys the share' do
            expect { share.reload }.to \
              raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
