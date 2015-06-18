require 'rails_helper'

describe V1::ListsController do
  describe 'GET #index' do
    let!(:lists) { create_list(:list, 3, topic: topic) }

    before { create_list(:list, 2) }

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

      context 'whos is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        it { is_expected.to respond_with(:ok) }

        it 'responds with the topics lists' do
          expect(json[:lists]).to match_array(lists_json(lists))
        end
      end
    end
  end

  describe 'GET #show' do
    before { set_auth_header(token) }

    before { get :show, topic_id: topic_id, id: id }

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:id) { list.id }

    let(:list) { create(:list) }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:not_found) }

      context 'whos is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        context 'with invalid id' do
          let(:id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid id' do
          it { is_expected.to respond_with(:ok) }

          it 'responds with the topics lists' do
            expect(json[:list]).to eq(list_json(list))
          end
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

      context 'whos is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        context 'without params' do
          it { is_expected.to respond_with(:unprocessable_entity) }
        end

        context 'with params' do
          let(:params) { {list: {name: name}} }

          let(:name) { build(:list).name }

          context 'but with invalid name' do
            let(:name) { [nil, SecureRandom.hex(128)].sample }

            it { is_expected.to respond_with(:unprocessable_entity) }

            it 'responds with error details' do
              expect(json[:errors][:name]).to be_present
            end
          end

          context 'that are valid' do
            let(:list) { List.find(json[:list][:id]) }

            it { is_expected.to respond_with(:created) }

            it 'responds with the list' do
              expect(json[:list]).to eq(list_json(list))
            end

            it 'sets the correct name' do
              expect(list.name).to eq(name)
            end

            it 'connects the list with the topic' do
              expect(list.topic).to eq(topic)
            end
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    before { set_auth_header(token) }

    before { patch :update, params.merge(topic_id: topic_id, id: id) }

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:id) { list.id }

    let(:list) { create(:list) }

    let(:params) { {} }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:not_found) }

      context 'whos is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        context 'with invalid id' do
          let(:id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid id' do
          context 'without params' do
            it { is_expected.to respond_with(:unprocessable_entity) }
          end

          context 'with params' do
            let(:params) { {list: {name: name}} }

            let(:name) { build(:list).name }

            context 'but with invalid name' do
              let(:name) { [nil, SecureRandom.hex(128)].sample }

              it { is_expected.to respond_with(:unprocessable_entity) }

              it 'responds with error details' do
                expect(json[:errors][:name]).to be_present
              end
            end

            context 'that are valid' do
              it { is_expected.to respond_with(:ok) }

              it 'responds with the updated list' do
                expect(json[:list]).to eq(list_json(list.reload))
              end

              it 'sets the correct name' do
                expect(list.reload.name).to eq(name)
              end
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

    let(:topic) { list.topic }

    let(:id) { list.id }

    let(:list) { create(:list) }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      it { is_expected.to respond_with(:not_found) }

      context 'whos is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        context 'with invalid id' do
          let(:id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid id' do
          it { is_expected.to respond_with(:no_content) }

          it 'destroys the list' do
            expect { list.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
