module Api
  module V1
    class AccountController < ApplicationController
      def register
	encryption_provider = ActiveSupport::MessageEncryptor.new(
	  ENV["CRYPTO_KEY"]
	)  
        
        begin 
	  manager = AccountManager.new(
	    params[:data], 
	    encryption_provider
	  )
	  manager_response = manager.register
	rescue AccountError => e
          response = { message: e.message }
	  status = :unprocessable_entity
	rescue ActiveRecord::RecordInvalid => e
          response = { message: e.message }
	  status = :unprocessable_entity
        end

	if manager_response.class == Account 
	  response = { message: "success" }
	  status = :ok
	end

	render json: response, status: status 

      end
    end
  end
end
