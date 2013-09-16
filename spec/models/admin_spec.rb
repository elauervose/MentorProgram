require 'spec_helper'

describe Admin do

  subject(:admin) { FactoryGirl.build :admin }

  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :authenticate }
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
        Admin.create!(email: admin.email,
                      password: "foobar", password_confirmation: "foobar")
        expect(admin).to_not be_valid
      end
    end
    describe "for password" do
      it "should not be valid without a password" do
        admin.password = ""
        admin.password_confirmation = ""
        expect(admin).to_not be_valid
      end
      it "should not be valid with incorrect password confirmation" do
        admin.password_confirmation = "invalid"
        expect(admin).to_not be_valid
      end
    end
  end

  describe "authenticate value" do
    before { admin.save }
    let(:found_admin) { Admin.find_by(email: admin.email) }

    describe "with valid password" do
      it { should eq found_admin.authenticate(admin.password) }
    end
    describe "with invalid password" do
      let(:admin_with_invalid_password) { found_admin.authenticate("invalid") }

      it { should_not eq admin_with_invalid_password }
      specify { expect(admin_with_invalid_password).to be_false }
    end
  end

end
