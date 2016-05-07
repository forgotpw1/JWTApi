require_relative '../../app/models/login'
describe Login do
  let(:missing_params){
    {
      username: 'fred_flintstone',
    }
  } 	  
  let(:valid){
    {
      username: 'fred_flintstone',
      password: 'abcdefg123'
    }
  } 
  let(:invalid){
    {
      username: 'wilma',
      password: 'abcdefg123'
    }
  } 
  
  let (:encryption_service) {
    double("encryption_service")
  }
  
  let (:jwt_service) {
    double("jwt_service")
  }

  let(:login) { Login.new(valid, encryption_service, jwt_service) }  

  it "should raise an error if missing any parameter" do
    expect{
      Login.new(missing_params)
    }.to raise_error("Missing parameters. Make sure you are including username, and password.")
  end

  it "should initialize Login with valid parameters" do
   expect{
      account_manager = Login.new(valid)
   } 
  end

  describe ".authenticate" do
    it "should return false if no username found"  do
      allow(Account).to receive_message_chain(:where, :first).and_return(nil)
      expect(login.send(:authenticate)).to eq(false)
    end
    it "should return false if password does not match" do
      allow(Account).to receive_message_chain(
        :where, 
	:first
      ).and_return(OpenStruct.new(password: "a"))
      allow(encryption_service).to receive(:decrypt_and_verify).and_return("donkey")
      new_login = Login.new(valid, encryption_service,jwt_service) 
      expect(new_login.send(:authenticate)).to eq(false)
    end

    it "should return true if decrypted matches submitted" do
      allow(Account).to receive_message_chain(
        :where, 
	:first
      ).and_return(OpenStruct.new(password: "abc"))
      allow(encryption_service).to receive(:decrypt_and_verify).and_return("abcdefg123")
      new_login = Login.new(valid, encryption_service,jwt_service) 
      expect(new_login.send(:authenticate)).to eq(true)
    end
  end
  describe ".get_jwt" do
    before :each do
    end

    it "should raise error if account did not authenticate" do 
      allow_any_instance_of(Login).to receive(:authenticate).and_return(false)
      expect{ login.get_jwt }.to raise_error("Authentication failed")
    end

    it "should return JWT if authentication passes" do
      allow_any_instance_of(Login).to receive(:authenticate).and_return(true)
      allow(jwt_service).to receive(:encode).and_return("panda")

      jwt_login = Login.new(valid, encryption_service,jwt_service) 
      expect(jwt_login.get_jwt).to eq("panda") 
    end
  end
end
