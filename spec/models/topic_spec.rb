require 'rails_helper'

RSpec.describe Topic do
  it { is_expected.to belong_to(:contact) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:heading_level) }
  it { is_expected.to validate_inclusion_of(:heading_level).in_array([1,2,3]) }
end
