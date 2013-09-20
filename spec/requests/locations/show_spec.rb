require 'spec_helper'

describe "show location" do
  let(:admin) { FactoryGirl.create :admin }
  let(:location) { FactoryGirl.create :location }
  before do
    sign_in(admin)
    visit location_path(location)
  end

  it "should have the location's name" do
    expect(page).to have_selector 'h1', text: location.name
  end
end
