module EmailableConcernSpecs
  shared_examples_for Emailable do
    let(:object) { subject }
    
    it { should respond_to :email }

    describe "validations" do
      it "should prevent a blank email address" do
        object.email = ""
        expect(object).to_not be_valid
      end
      it "should prevent an valid email address" do
        %w{ not_an_email @invalid.com personATplaceDOTcom
          guy@place.123 }.each do |invalid_email|
          object.email = invalid_email
          expect(object).to_not be_valid
          end
      end
      it "should prevent too long an email address" do
        object.email = "a"*245 + "@example.com"
        expect(object).to_not be_valid
      end
    end
  end
end
