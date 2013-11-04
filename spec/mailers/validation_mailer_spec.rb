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

  describe "deleting the request" do
    context "for a mentor_ask" do
      it "should contain a link to view and delete the request" do
        mentor_ask = FactoryGirl.create(:mentor_ask, validated_at: nil)
        validation_email = ValidationMailer.request_validation(mentor_ask).
          deliver
        expect(validation_email.body).to have_link("delete_request", href:
          mentor_ask_path(mentor_ask, token: mentor_ask.token))
      end
    end
    context "for a pair_ask" do
      it "should contain a link to view and delete the request" do
        pair_ask = FactoryGirl.create(:pair_ask, validated_at: nil)
        validation_email = ValidationMailer.request_validation(pair_ask).
          deliver
        expect(validation_email.body).to have_link("delete_request", href:
          pair_ask_path(pair_ask, token: pair_ask.token))
      end
    end
  end

end
