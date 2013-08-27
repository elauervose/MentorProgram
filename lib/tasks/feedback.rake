namespace :notification do
  desc "Send request for feedback emails to mentor and mentee"
  task feedback: :environment do
    Answer.solicit_feedback
  end
end
