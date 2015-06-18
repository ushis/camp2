require 'rails_helper'

describe Token do
  describe '.derive' do
    subject { Token.derive(scope, ttl) }

    let(:scope) { :test }

    let(:ttl) { 1.week }

    it { is_expected.to be_a(Class) }

    it { is_expected.to be < Token }

    its(:scope) { is_expected.to eq(scope) }

    its(:ttl) { is_expected.to eq(ttl) }
  end

  describe '.inspect' do
    subject { Token.derive(:test, 1.week).inspect }

    it { is_expected.to eq('Token (scope: :test, ttl: 7 days)') }
  end

  describe '.for' do
    subject { Token.derive(scope, ttl).for(user) }

    let(:scope) { :test }

    let(:ttl) { 1.week }

    let(:user) { create(:user) }

    its(:id) { is_expected.to eq(user.id) }

    its(:scope) { is_expected.to eq(scope.to_s) }

    its(:exp) { is_expected.to eq(1.week.from_now.to_i) }
  end

  describe '.from_s' do
    subject { klass.from_s(token) }

    let(:klass) { Token.derive(:test, 1.week) }

    let(:token) { klass.new(id, scope, exp).to_s }

    let(:id) { rand(1_000) }

    let(:scope) { :test }

    let(:exp) { rand(1_000).minutes.from_now.to_i }

    context 'token is expired' do
      let(:exp) { 1.minute.ago.to_i }

      it 'raises a error' do
        expect { klass.from_s(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'token has invalid scope' do
      let(:scope) { :invalid }

      it 'raises a error' do
        expect { klass.from_s(token) }.to raise_error(JWT::DecodeError)
      end
    end

    context 'token is valid' do
      its(:id) { is_expected.to eq(id) }

      its(:scope) { is_expected.to eq(scope.to_s) }

      its(:exp) { is_expected.to eq(exp) }
    end
  end

  describe '#valid_scope?' do
    subject { token.valid_scope? }

    let(:token) { klass.new(rand(1_000), scope, 12.minutes.ago.to_i) }

    let(:klass) { Token.derive(:test, 1.week) }

    context 'with invalid scope' do
      let(:scope) { :invalid }

      it { is_expected.to eq(false) }
    end

    context 'with valid scope' do
      let(:scope) { :test }

      it { is_expected.to eq(true) }
    end
  end

  describe '#inspect' do
    subject { token.inspect }

    let(:token) { Token.new(12, :test, 123) }

    it { is_expected.to eq('#<Token id: 12, scope: :test, exp: 123>') }
  end
end
