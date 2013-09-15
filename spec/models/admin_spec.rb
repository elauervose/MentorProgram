require 'spec_helper'

describe Admin do

  subject(:admin) { FactoryGirl.build :admin }

  it { should respond_to :email }
  it { should be_valid }

  describe "validations" do
    describe "on email" do
      it "should prevent a blank email address" do
        admin.email = ""
        expect(admin).to_not be_valid
      end
      it "should prevent an valid email address" do
        %w{ not_an_email @invalid.com personATplaceDOTcom
          guy@place.123 }.each do |invalid_email|
          admin.email = invalid_email
          expect(admin).to_not be_valid
          end
      end
      it "should prevent too long an email address" do
        admin.email = "a"*245 + "@example.com"
        expect(admin).to_not be_valid
      end
      it "must have a unique email address" do
        Admin.create!(email: admin.email)
        expect(admin).to_not be_valid
      end
    end
  end
end
