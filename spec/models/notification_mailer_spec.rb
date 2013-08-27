require 'spec_helper'

describe NotificationMailer do
  let(:mentee) { FactoryGirl.create :ask }
  let(:mentor_attr) { FactoryGirl.attributes_for :answer }
  let(:admin_email) { "admin@example.com" }

  before { mentee.create_answer(mentor_attr) }

  describe "mentor answers a tutoring request" do
    subject!(:mail) { NotificationMailer.
      create_response(mentee.answer.email, mentee.email).deliver }
    
    it "should be sent from the admin email account" do
      expect(mail.from).to include(admin_email)
    end

    it "should be sent to the mentor and mentee" do
      expect(mail.to).to include(mentee.email)
      expect(mail.to).to include(mentee.answer.email)
    end

    it "should be sent successfully" do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
  end
  
end

