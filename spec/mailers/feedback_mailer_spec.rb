require 'spec_helper'

describe 'FeedbackMailer' do
  let(:mentee) { FactoryGirl.create :ask }
  let(:mentor_attr) { FactoryGirl.attributes_for :answer }
  let(:admin_email) { "admin@example.com" }

  describe "soliciting feedback" do
    before do
      mentee.create_answer(mentor_attr)
    end

    context "a month after mentor sign up" do    
      before do
        mentee.answer.created_at = 1.month.ago
        mentee.answer.save
      end
      it "should send out two emails" do
        expect { Answer.solicit_feedback }.
          to change{ ActionMailer::Base.deliveries.size }.by(2)
      end
      specify "email should be sent from administrator account" do
        mail = ActionMailer::Base.deliveries.last
        expect(mail.from).to include(admin_email)
      end
    end
    context "more or less than a month after mentor sign up" do
     it "should not send any emails before one month" do 
       mentee.answer.created_at = 1.month.ago + 1.day
       expect { Answer.solicit_feedback }.
         to_not change{ ActionMailer::Base.deliveries.size }
     end
     it "should not send any emails after one month" do
       mentee.answer.created_at = 1.month.ago - 1.day
       expect { Answer.solicit_feedback }.
         to_not change{ ActionMailer::Base.deliveries.size }
     end
    end
  end
end

    

