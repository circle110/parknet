require 'spec_helper'

describe AccessController do

  describe "GET 'menu'" do
    it "returns http success" do
      get 'menu'
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
