require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:pets) }
  it { is_expected.to have_many(:dogwalkings) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }

end
