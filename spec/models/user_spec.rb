require 'rails_helper'

describe User do
  it { is_expected.to have_secure_password }

  describe 'associations' do
    it { is_expected.to have_many(:comments).dependent(:nullify).inverse_of(:user) }
    it { is_expected.to have_many(:shares).dependent(:destroy).inverse_of(:user) }
    it { is_expected.to have_many(:topics).through(:shares) }
    it { is_expected.to have_many(:lists).through(:topics) }
    it { is_expected.to have_many(:items).through(:lists) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
    it { is_expected.to validate_confirmation_of(:password) }
    it { is_expected.to allow_value('test+somthing@example.com').for(:email) }
    it { is_expected.to_not allow_value('@gmail.com').for(:email) }

    describe 'uniqueness validations' do
      before { create(:user) }

      it { is_expected.to validate_uniqueness_of(:email) }
    end

    describe 'when password is present' do
      subject { build(:user, password: 'secret') }

      it { is_expected.to validate_presence_of(:password_confirmation) }
    end

    describe 'when password is blank' do
      subject { build(:user, password: nil) }

      it { is_expected.to_not validate_presence_of(:password_confirmation) }
    end
  end

  describe '#email_with_name' do
    subject { user.email_with_name }

    let(:user) { build(:user, email: 'bill@example.com', name: 'Bill Murray') }

    it { is_expected.to eq('Bill Murray <bill@example.com>') }
  end
end
