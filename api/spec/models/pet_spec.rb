require 'rails_helper'

RSpec.describe Pet, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:dogwalkings) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :age }
  it { is_expected.to validate_presence_of :gender }
  it { is_expected.to validate_presence_of :breed }
  it { is_expected.to validate_presence_of :size }
  it { is_expected.to validate_presence_of :user_id }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:age) }
  it { is_expected.to respond_to(:gender) }
  it { is_expected.to respond_to(:breed) }
  it { is_expected.to respond_to(:size) }
  it { is_expected.to respond_to(:user_id) }
end
