require 'rails_helper'

describe CommentPolicy do
  describe '#show?' do
    subject { CommentPolicy.new(user, record).show? }

    let(:record) { create(:comment) }

    context 'user is not related to the comment' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is releated to the comment' do
      let(:user) { create(:share, topic: record.item.list.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#create?' do
    subject { CommentPolicy.new(user, record).create? }

    let(:record) { build(:comment, item: item) }

    let(:item) { create(:item) }

    context 'user is not related to the comment' do
      let(:user) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user is releated to the comment' do
      let(:user) { create(:share, topic: item.list.topic).user }

      it { is_expected.to eq(true) }
    end
  end

  [:update?, :destroy?].each do |method|
    describe "##{method}" do
      subject { CommentPolicy.new(user, record).send(method) }

      let(:record) do
        create(:comment, user: author, item: item, created_at: created_at)
      end

      let(:created_at) { 9.minutes.ago }

      let(:author) { share.user }

      let(:item) { create(:item, list: list) }

      let(:list) { create(:list, topic: topic) }

      let(:topic) { share.topic }

      let(:share) { create(:share) }

      context 'user is not related to the comment' do
        let(:user) { create(:user) }

        it { is_expected.to eq(false) }

        context 'but is the author' do
          let(:user) { author }

          let(:author) { create(:user) }

          it { is_expected.to eq(false) }
        end
      end

      context 'user is releated to the comment' do
        let(:user) { create(:share, topic: topic).user }

        it { is_expected.to eq(false) }

        context 'and is the author' do
          let(:user) { author }

          it { is_expected.to eq(true) }

          context 'and the comment is older than 10 minutes' do
            let(:created_at) { 11.minutes.ago }

            it { is_expected.to eq(false) }
          end
        end
      end
    end
  end

  describe '#permitted_attributes' do
    its(:permitted_attributes) { is_expected.to match_array(%i(comment)) }
  end

  describe '#accessible_attributes' do
    let(:attrs) { %i(id comment created_at updated_at) }

    its(:accessible_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_associations' do
    its(:accessible_associations) { is_expected.to match_array(%i(user)) }
  end
end
