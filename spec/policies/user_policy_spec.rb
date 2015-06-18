require 'rails_helper'

describe UserPolicy do
  describe '#show?' do
    subject { UserPolicy.new(user, record).show? }

    let(:user) { create(:user) }

    context 'user and require are not related' do
      let(:record) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user equals record' do
      let(:record) { user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#create?' do
    its(:create?) { is_expected.to eq(true) }
  end

  describe '#update?' do
    subject { UserPolicy.new(user, record).update? }

    let(:user) { create(:user) }

    context 'user and require are not related' do
      let(:record) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user equals record' do
      let(:record) { user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#destroy?' do
    subject { UserPolicy.new(user, record).destroy? }

    let(:user) { create(:user) }

    context 'user and require are not related' do
      let(:record) { create(:user) }

      it { is_expected.to eq(false) }
    end

    context 'user equals record' do
      let(:record) { user }

      it { is_expected.to eq(true) }
    end
  end

  describe '#permitted_attributes' do
    let(:attrs) { %i(name email password password_confirmation) }

    its(:permitted_attributes) { is_expected.to match_array(attrs) }
  end

  describe '#accessible_attributes' do
    subject { UserPolicy.new(user, record).accessible_attributes }

    let(:user) { create(:user) }

    context 'user and require are not related' do
      let(:record) { create(:user) }

      it { is_expected.to match_array(%i(id name)) }
    end

    context 'user equals record' do
      let(:record) { user }

      let(:attrs) { %i(id name email access_token updated_at created_at) }

      it { is_expected.to match_array(attrs) }
    end
  end

  describe '#accessible_associations' do
    its(:accessible_associations) { is_expected.to eq([]) }
  end
end
