require 'rails_helper'

describe V1::ItemsController do
  describe 'GET #index' do
    let!(:items) { create_list(:item, 3, list: list) }

    before { create_list(:item, 2) }

    before { set_auth_header(token) }

    before { get :index, topic_id: topic_id, list_id: list_id }

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

    let(:list) { create(:list) }

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

        context 'with invalid list id' do
          let(:list_id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid list id' do
          it { is_expected.to respond_with(:ok) }

          it 'responds with the lists items' do
            expect(json[:items]).to match_array(items_json(items))
          end
        end
      end
    end
  end

  describe 'GET #show' do
    before { set_auth_header(token) }

    before { get :show, topic_id: topic_id, list_id: list_id, id: id }

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

    let(:list) { item.list }

    let(:id) { item.id }

    let(:item) { create(:item) }

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

        context 'with invalid list id' do
          let(:list_id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid id' do
          let(:id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          it { is_expected.to respond_with(:ok) }

          it 'responds with the item' do
            expect(json[:item]).to eq(item_json(item))
          end
        end
      end
    end
  end

  describe 'POST #create' do
    before { set_auth_header(token) }

    before { post :create, params.merge(topic_id: topic_id, list_id: list_id) }

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

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

      context 'who is related to the topic' do
        let(:user) { create(:share, topic: topic).user }

        context 'with invalid list id' do
          let(:list_id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid list id' do
          describe 'but without params' do
            it { is_expected.to respond_with(:unprocessable_entity) }
          end

          context 'and params' do
            let(:params) { {item: {name: name}} }

            let(:name) { build(:item).name }

            context 'but invalid name' do
              let(:name) { [nil, SecureRandom.hex(128)].sample }

              it { is_expected.to respond_with(:unprocessable_entity) }

              it 'responds with error details' do
                expect(json[:errors][:name]).to be_present
              end
            end

            context 'that are valid' do
              let(:item) { Item.find(json[:item][:id]) }

              it { is_expected.to respond_with(:created) }

              it 'responds with the item' do
                expect(json[:item]).to eq(item_json(item))
              end

              it 'sets the correct name' do
                expect(item.name).to eq(name)
              end

              it 'connects the item with the list' do
                expect(item.list).to eq(list)
              end
            end
          end
        end
      end
    end
  end

  describe 'PATCH #update' do
    before { set_auth_header(token) }

    before do
      patch :update, params.merge(topic_id: topic_id, list_id: list_id, id: id)
    end

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

    let(:list) { item.list }

    let(:id) { item.id }

    let(:item) { create(:item) }

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

        context 'with invalid list id' do
          let(:list_id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid id' do
          let(:id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          context 'but without params' do
            it { is_expected.to respond_with(:unprocessable_entity) }
          end

          context 'and params' do
            let(:params) { {item: {name: name}} }

            let(:name) { build(:item).name }

            context 'but invalid name' do
              let(:name) { [nil, SecureRandom.hex(128)].sample }

              it { is_expected.to respond_with(:unprocessable_entity) }

              it 'responds with error details' do
                expect(json[:errors][:name]).to be_present
              end
            end

            context 'that are valid' do
              it { is_expected.to respond_with(:ok) }

              it 'responds with the item' do
                expect(json[:item]).to eq(item_json(item.reload))
              end

              it 'sets the correct name' do
                expect(item.reload.name).to eq(name)
              end
            end
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { set_auth_header(token) }

    before { delete :destroy, topic_id: topic_id, list_id: list_id, id: id }

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

    let(:list) { item.list }

    let(:id) { item.id }

    let(:item) { create(:item) }

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

        context 'with invalid list id' do
          let(:list_id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid id' do
          let(:id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          it { is_expected.to respond_with(:no_content) }

          it 'destroys the item' do
            expect { item.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end
  end
end
