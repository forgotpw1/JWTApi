module Api
  module V1
    class AccountController < ApplicationController
      def register
	encryption_provider = ActiveSupport::MessageEncryptor.new(
	  ENV["CRYPTO_KEY"]
	)  
        
        begin
	  data = {}
	  data.merge!(username: params[:username]) if params[:username]
	  data.merge!(email: params[:email]) if params[:email]
	  data.merge!(password: params[:password]) if params[:password]
	  manager = AccountManager.new(
	    data, 
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

      def login
	encryption_provider = ActiveSupport::MessageEncryptor.new(
	  ENV["CRYPTO_KEY"]
	)  
	data = {}
	data.merge!(username: params[:username]) if params[:username]
        data.merge!(password: params[:password]) if params[:password]
	
	begin
          jwt_service = JWTService.new(ENV["CRYPTO_KEY"])
          login = Login.new(data, encryption_provider, jwt_service)
	  jwt = login.get_jwt
	  response = { jwt: jwt }
	  status = :ok
        rescue LoginError => e
	  response = { message: e.message } 
	  status = :unprocessable_entity
	end		
        
	render json: response, status: status 
      end
    end
  end
end
