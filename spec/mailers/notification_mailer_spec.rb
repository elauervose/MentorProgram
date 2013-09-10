require 'spec_helper'

describe NotificationMailer do
  let(:mentee) { FactoryGirl.create :ask }
  let(:mentor_attr) { FactoryGirl.attributes_for :answer }
  let(:admin_email) { "mentors@hatsnpants.com" }

  before { mentee.create_answer(mentor_attr) }

  describe "mentor answers a tutoring request" do
    describe "email to mentor" do
      let!(:mail_to_mentor) { NotificationMailer.
        introduce_mentee_to_mentor(mentee).deliver }
      
      it "should be sent from the admin email account" do
        expect(mail_to_mentor.from).to include(admin_email)
      end

      it "should be sent to the mentor" do
        expect(mail_to_mentor.to).to include(mentee.answer.email)
      end

      it "should be sent successfully" do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
    end
    describe "email to mentee" do
      let!(:mail_to_mentee) { NotificationMailer.
        introduce_mentor_to_mentee(mentee).deliver }
      
      it "should be sent from the admin email account" do
        expect(mail_to_mentee.from).to include(admin_email)
      end

      it "should be sent to the mentee" do
        expect(mail_to_mentee.to).to include(mentee.email)
      end

      it "should be sent successfully" do
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
    end
  end
  
end
