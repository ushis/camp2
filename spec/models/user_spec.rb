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

  describe '.find_by_access_token' do
    subject { User.find_by_access_token(token) }

    let(:token) { Token.new(id, scope, exp).to_s }

    let(:user) { create(:user) }

    let(:id) { user.id }

    let(:scope) { :access }

    let(:exp) { 1.week.from_now.to_i }

    it { is_expected.to eq(user) }

    context 'given a token with invalid id' do
      let(:id) { -1 }

      it { is_expected.to eq(nil) }
    end

    context 'given a token with invalid scope' do
      let(:scope) { :invalid }

      it { is_expected.to eq(nil) }
    end

    context 'given an expired token' do
      let(:exp) { 1.minute.ago.to_i }

      it { is_expected.to eq(nil) }
    end
  end

  describe '.find_by_access_token!' do
    subject { User.find_by_access_token!(token) }

    let(:token) { Token.new(id, scope, exp).to_s }

    let(:user) { create(:user) }

    let(:id) { user.id }

    let(:scope) { :access }

    let(:exp) { 1.week.from_now.to_i }

    it { is_expected.to eq(user) }

    context 'given a token with invalid id' do
      let(:id) { -1 }

      it 'raises an error' do
        expect { User.find_by_access_token!(token) }.to \
          raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'given a token with invalid scope' do
      let(:scope) { :invalid }

      it 'raises an error' do
        expect { User.find_by_access_token!(token) }.to \
          raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'given an expired token' do
      let(:exp) { 1.minute.ago.to_i }

      it 'raises an error' do
        expect { User.find_by_access_token!(token) }.to \
          raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#access_token' do
    subject { User.tokens[:access].from_s(token) }

    let(:token) { user.access_token }

    let(:user) { create(:user) }

    its(:id) { is_expected.to eq(user.id) }

    its(:scope) { is_expected.to eq('access') }

    its(:exp) { is_expected.to eq(1.week.from_now.to_i) }
  end

  describe '#email_with_name' do
    subject { user.email_with_name }

    let(:user) { build(:user, email: 'bill@example.com', name: 'Bill Murray') }

    it { is_expected.to eq('Bill Murray <bill@example.com>') }
  end
end
