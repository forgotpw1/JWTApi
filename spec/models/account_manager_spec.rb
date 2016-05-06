require_relative '../../app/models/account_manager'
describe AccountManager do
  let(:missing_params){
    {
      username: 'fred_flintstone',
      password: 'abcdefg123'
    }
  } 	  
  let(:invalid_email){
    {
      username: 'fred_flintstone',
      email: "fred@gmail",
      password: 'abcdefg123'
    }
  } 	  
  let(:valid){
    {
      username: 'fred_flintstone',
      email: "fred@gmail.com",
      password: 'abcdefg123'
    }
  } 
  
  let (:encryption_service) {
    double()
  }
  
  let(:manager) { AccountManager.new(valid, encryption_service) }  

  it "should raise an error if missing any parameter" do
    expect{
      account_manager = AccountManager.new(missing_params)
    }.to raise_error("Missing parameters. Make sure you are including email, username, and password.")
  end

  it "should raise an error if missing a valid email" do
    expect{
      account_manager = AccountManager.new(invalid_email)
    }.to raise_error("Invalid email")
  end

  it "should initialize a new Account Manager with valid input" do
   expect{
      account_manager = AccountManager.new(valid)
   } 
  end

  describe ".register" do
    before :each do
      @account = double()
      allow(encryption_service).to receive(:encrypt_and_sign).at_least(1).times
      allow(Account).to receive(:new) { @account }
      allow(@account).to receive_message_chain(:errors, :messages)
    end

    it "should return errors if new account was not saved" do
      allow(@account).to receive(:save!) { false }
      expect(@account).to receive(:errors)
      manager.register
    end

    it "should return account if new account was saved" do
      allow(@account).to receive(:save!) { true }
      expect(manager.register).to eq(@account)
    end

    it "should encrypt password and email data with AES 256 encryption" do
      allow(@account).to receive(:save!) { true }
      expect(encryption_service).to receive(:encrypt_and_sign).exactly(2).times
      manager.register
    end
  end
end
