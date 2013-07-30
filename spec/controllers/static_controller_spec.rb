require 'spec_helper'

describe StaticController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'mentors'" do
    it "returns http success" do
      get 'mentors'
      response.should be_success
    end
  end

  describe "GET 'mentees'" do
    it "returns http success" do
      get 'mentees'
      response.should be_success
    end
  end

  describe "GET 'prep'" do
    it "returns http success" do
      get 'prep'
      response.should be_success
    end
  end

  describe "GET 'resources'" do
    it "returns http success" do
      get 'resources'
      response.should be_success
    end
  end

end
