require_relative '../../../rails_helper'
module API 
  module V1
    describe "Account registration API", :type => :request  do
      let(:encryption_service) { ActiveSupport::MessageEncryptor.new(ENV["CRYPTO_KEY"])  }
      it "should reject Missing Parameters" do
	post "/api/v1/account/register", data: {
#	  username: "FredFlintstone",
	  email: "fred@example.com",
	  password: "abcdefg"
	}

	expect(response.status).to equal(422)
      end
      
      it "should return a success upon sending valid parameters" do
	post "/api/v1/account/register", data: {
	  username: "FredFlintstone",
	  email: "fred@example.com",
	  password: "abcdefg"
	}

	expect(response.status).to eq(200)
      end
      

      it "should not process the creation of a duplicate entity" do
	manager = AccountManager.new({
	  username: "FredFlintstone",
	  email: "fred@example.com",
	  password: "abcdefg"

	}, encryption_service)
	manager.register
	post "/api/v1/account/register", data: {
	  username: "FredFlintstone",
	  email: "fred@example.com",
	  password: "abcdefg"
	}

	expect(response.status).to eq(422)
      end
    end
  end
end
