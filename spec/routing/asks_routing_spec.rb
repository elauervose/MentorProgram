require "spec_helper"

describe AsksController do
  describe "routing" do

    it "routes to #index" do
      get("/asks").should route_to("asks#index")
    end

    it "routes to #new" do
      get("/asks/new").should route_to("asks#new")
    end

    it "routes to #show" do
      get("/asks/1").should route_to("asks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/asks/1/edit").should route_to("asks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/asks").should route_to("asks#create")
    end

    it "routes to #update" do
      put("/asks/1").should route_to("asks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/asks/1").should route_to("asks#destroy", :id => "1")
    end

  end
end
