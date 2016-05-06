class AccountManager
  REQUIRED_FIELDS = [:username, :email, :password]
  def initialize(attr = {}, encryption_service = nil)
    keys = attr.keys.map(&:to_sym)
    attr = Hash[attr.map{ |k, v| [k.to_sym, v] }]
    raise AccountError, "Missing parameters. Make sure you are including email, username, and password." unless REQUIRED_FIELDS - keys == [] 
    raise AccountError, "Invalid email" unless attr[:email].match(/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
    @email = attr[:email]
    @password = attr[:password]
    @username = attr[:username]
    @crypt = encryption_service
  end

  def register
    @email_encrypted = @crypt.encrypt_and_sign(@email)
    @password_encrypted = @crypt.encrypt_and_sign(@password)
    account = Account.new(
      email: @email_encrypted,
      username: @username,
      password: @password_encrypted
    )
    
    return account.save! ? account : account.errors.messages
    
  end
  
end

