class Login 
  REQUIRED_FIELDS = [:username, :password]

  def initialize(attr = {}, encryption_service = nil, jwt_service = nil)
    keys = attr.keys.map(&:to_sym)
    attr = Hash[attr.map{ |k, v| [k.to_sym, v] }]
    raise AccountError, "Missing parameters. Make sure you are including username, and password." unless REQUIRED_FIELDS - keys == [] 
    @password = attr[:password]
    @username = attr[:username]
    @payload = {username: @username, password: @password}
    @crypt = encryption_service
    @jwt_service = jwt_service
  end

  def  get_jwt 
    raise LoginError, "Authentication failed" unless authenticate
    return  @jwt_service.encode(@payload)
  end

private

  def authenticate
    @account = Account.where(username: @username).first	  
    return false if @account == nil  
    pass = @crypt.decrypt_and_verify(@account.password) == @password ? true : false
    return pass
  end
end

