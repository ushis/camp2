require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory|
  describe "#{factory} factory" do
    subject { build(factory) }

    it { is_expected.to be_valid }
  end
end
