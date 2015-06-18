require 'rails_helper'

describe ApplicationPolicy do
  its(:show?) { is_expected.to eq(false) }
  its(:create?) { is_expected.to eq(false) }
  its(:update?) { is_expected.to eq(false) }
  its(:destroy?) { is_expected.to eq(false) }
  its(:permitted_attributes) { is_expected.to eq([]) }
  its(:accessible_attributes) { is_expected.to eq([]) }
  its(:accessible_associations) { is_expected.to eq([]) }
end
