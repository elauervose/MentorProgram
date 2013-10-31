require 'spec_helper'

describe ValidationMailer do
  let(:ask) { FactoryGirl.create(:ask, validated_at = nil) }
  let(:admin_email) { "mentors@hatsnpants.com" }

  describe "email requestion validation of request" do
    let!(:validation_email) { ValidationMailer.request_validation(ask).deliver }

    it "should be sent from the admin email account" do
      expect(validation_email.from).to include(admin_email)
    end

    it "should be sent to the email of request maker" do
      expect(validation_email.to).to include(ask.email)
    end

    it "should contain the link for validation" do
      expect(validation_email.body).to have_link(
        validate_asks_path(token: ask.token))
    end

    it "should be sent successfully" do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
  end

end


