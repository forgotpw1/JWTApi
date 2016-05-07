require 'jwt'

# A wrapper for the JWT package for the HMAC SHA1-256 algorithm
class JWTService
   def initialize(key = nil)
     raise "Key required " if key == nil
     @key = key
   end	   

   def encode(payload)
     JWT.encode(payload, @key, 'HS256')
   end

   def decode(payload)
   end
end


