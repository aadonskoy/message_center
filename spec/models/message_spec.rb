require "rails_helper"

RSpec.describe Message, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_length_of(:text).is_at_most(Message::TEXT_BODY_LENGTH) }
    it { is_expected.to validate_length_of(:phone_number).is_at_most(Message::PHONE_NUMBER_LENGTH) }
  end
end
