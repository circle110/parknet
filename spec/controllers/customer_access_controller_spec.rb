require 'spec_helper'

describe CustomerAccessController do

  describe "GET 'browse'" do
    it "returns http success" do
      get 'browse'
      response.should be_success
    end
  end

  describe "GET 'login'" do
    it "returns http success" do
      get 'login'
      response.should be_success
    end
  end

end
