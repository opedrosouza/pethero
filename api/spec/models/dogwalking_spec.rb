require 'rails_helper'

RSpec.describe Dogwalking, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:pets) }

  it { is_expected.to validate_presence_of :schedule_date }
  it { is_expected.to validate_presence_of :init_hour }
  it { is_expected.to validate_presence_of :finish_hour }
  it { is_expected.to validate_presence_of :duration }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_presence_of :latitude }
  it { is_expected.to validate_presence_of :longitude }

  it { is_expected.to respond_to(:schedule_date) }
  it { is_expected.to respond_to(:init_hour) }
  it { is_expected.to respond_to(:finish_hour) }
  it { is_expected.to respond_to(:duration) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:latitude) }
  it { is_expected.to respond_to(:longitude) }
end
