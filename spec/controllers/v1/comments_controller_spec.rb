require 'rails_helper'

describe V1::CommentsController do
  describe 'GET #index' do
    let!(:comments) { create_list(:comment, 3, item: item) }

    before { create_list(:comment, 2) }

    before { set_auth_header(token) }

    before do
      get :index, topic_id: topic_id, list_id: list_id, item_id: item_id
    end

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

    let(:list) { item.list }

    let(:item_id) { item.id }

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

        context 'with invalid item id' do
          let(:item_id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          it { is_expected.to respond_with(:ok) }

          it 'responds with the items comments' do
            expect(json[:comments]).to match_array(comments_json(comments))
          end
        end
      end
    end
  end

  describe 'GET #show' do
    before { set_auth_header(token) }

    before do
      get :show, topic_id: topic_id, list_id: list_id, item_id: item_id, id: id
    end

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

    let(:list) { item.list }

    let(:item_id) { item.id }

    let(:item) { comment.item }

    let(:id) { comment.id }

    let(:comment) { create(:comment) }

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

        context 'with invalid item id' do
          let(:item_id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid id' do
          let(:id) { create(:comment).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          it { is_expected.to respond_with(:ok) }

          it 'responds with the comment' do
            expect(json[:comment]).to eq(comment_json(comment))
          end
        end
      end
    end
  end

  describe 'POST #create' do
    before { set_auth_header(token) }

    before do
      post(:create, params.merge({
        topic_id: topic_id,
        list_id: list_id,
        item_id: item_id
      }))
    end

    let(:topic_id) { topic.id }

    let(:topic) { list.topic }

    let(:list_id) { list.id }

    let(:list) { item.list }

    let(:item_id) { item.id }

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

        context 'with invalid item id' do
          let(:item_id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          context 'but without params' do
            it { is_expected.to respond_with(:unprocessable_entity) }
          end

          context 'and params' do
            let(:params) { {comment: {comment: body}} }

            let(:body) { build(:comment).comment }

            context 'but without comment body' do
              let(:body) { '    ' }

              it { is_expected.to respond_with(:unprocessable_entity) }

              it 'responds with error details' do
                expect(json[:errors][:comment]).to be_present
              end
            end

            context 'that are valid' do
              let(:comment) { Comment.find(json[:comment][:id]) }

              it { is_expected.to respond_with(:created) }

              it 'responds with the comment' do
                expect(json[:comment]).to eq(comment_json(comment))
              end

              it 'sets the correct comment body' do
                expect(comment.comment).to eq(body)
              end

              it 'connects the comment with the item' do
                expect(comment.item).to eq(item)
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
      patch(:update, params.merge({
        topic_id: topic_id,
        list_id: list_id,
        item_id: item_id,
        id: id
      }))
    end

    let(:topic_id) { topic.id }

    let(:topic) { share.topic }

    let(:list_id) { list.id }

    let(:list) { create(:list, topic: topic) }

    let(:item_id) { item.id }

    let(:item) { create(:item, list: list) }

    let(:id) { comment.id }

    let(:comment) do
      create(:comment, item: item, user: author, created_at: created_at)
    end

    let(:author) { create(:user) }

    let(:share) { create(:share) }

    let(:created_at) { Time.zone.now }

    let(:params) { {} }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      context 'who is not related to the topic' do
        it { is_expected.to respond_with(:not_found) }

        context 'but the author' do
          let(:user) { author }

          it { is_expected.to respond_with(:not_found) }
        end
      end

      context 'who is related to the topic' do
        let(:user) { share.user }

        context 'with invalid list id' do
          let(:list_id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid item id' do
          let(:item_id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid id' do
          let(:id) { create(:comment).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          context 'but not as author' do
            it { is_expected.to respond_with(:forbidden) }
          end

          context 'as author' do
            let(:author) { user }

            context 'but the comment is older than 10 minutes' do
              let(:created_at) { 11.minutes.ago }

              it { is_expected.to respond_with(:forbidden) }
            end

            context 'but without params' do
              it { is_expected.to respond_with(:unprocessable_entity) }
            end

            context 'and params' do
              let(:params) { {comment: {comment: body}} }

              let(:body) { build(:comment).comment }

              context 'but without comment body' do
                let(:body) { '    ' }

                it { is_expected.to respond_with(:unprocessable_entity) }

                it 'responds with error details' do
                  expect(json[:errors][:comment]).to be_present
                end
              end

              context 'that are valid' do
                it { is_expected.to respond_with(:ok) }

                it 'responds with the comment' do
                  expect(json[:comment]).to eq(comment_json(comment.reload))
                end

                it 'sets the correct comment body' do
                  expect(comment.reload.comment).to eq(body)
                end
              end
            end
          end
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before { set_auth_header(token) }

    before do
      delete(:destroy, {
        topic_id: topic_id,
        list_id: list_id,
        item_id: item_id,
        id: id
      })
    end

    let(:topic_id) { topic.id }

    let(:topic) { share.topic }

    let(:list_id) { list.id }

    let(:list) { create(:list, topic: topic) }

    let(:item_id) { item.id }

    let(:item) { create(:item, list: list) }

    let(:id) { comment.id }

    let(:comment) do
      create(:comment, item: item, user: author, created_at: created_at)
    end

    let(:author) { create(:user) }

    let(:share) { create(:share) }

    let(:created_at) { Time.zone.now }

    context 'as visitor' do
      let(:token) { nil }

      it { is_expected.to respond_with(:unauthorized) }
    end

    context 'as logged in user' do
      let(:token) { user.access_token }

      let(:user) { create(:user) }

      context 'who is not related to the topic' do
        it { is_expected.to respond_with(:not_found) }

        context 'but the author' do
          let(:user) { author }

          it { is_expected.to respond_with(:not_found) }
        end
      end

      context 'who is related to the topic' do
        let(:user) { share.user }

        context 'with invalid list id' do
          let(:list_id) { create(:list).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid item id' do
          let(:item_id) { create(:item).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with invalid id' do
          let(:id) { create(:comment).id }

          it { is_expected.to respond_with(:not_found) }
        end

        context 'with valid ids' do
          context 'but not as author' do
            it { is_expected.to respond_with(:forbidden) }
          end

          context 'as author' do
            let(:author) { user }

            context 'but the comment is older than 10 minutes' do
              let(:created_at) { 11.minutes.ago }

              it { is_expected.to respond_with(:forbidden) }
            end

            context 'and the comment is still fresh' do
              it { is_expected.to respond_with(:no_content) }

              it 'destroys the comment' do
                expect { comment.reload }.to \
                  raise_error(ActiveRecord::RecordNotFound)
              end
            end
          end
        end
      end
    end
  end
end
