require 'spec_helper'

describe "Validating ask" do
  let(:ask) { FactoryGirl.create(:mentor_ask, validated_at: nil) }

  context "with a valid token" do
    before { visit validate_asks_path(token: ask.token) }

    it "results in the request being validated" do
      ask.reload
      expect(ask.validated?).to be_true
    end
    it "has a message confirming validation" do
      expect(page).to have_selector 'p',
        text: "Your request has been successfully validated"
    end
  end

  context "with an invalid token" do
    before { visit validate_asks_path(token: "invalid_token") }

    it "does not result in the request being validated" do
      ask.reload
      expect(ask.validated?).to be_false
    end
    it "has a message stating failure of validation" do
      expect(page).to have_selector 'p',
        text: "Sorry, we were unable to validate your request"
    end
  end

end
