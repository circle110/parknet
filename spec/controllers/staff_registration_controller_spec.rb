require 'spec_helper'

describe StaffRegistrationController do

  describe "GET 'registration'" do
    it "returns http success" do
      get 'registration'
      response.should be_success
    end
  end

end
