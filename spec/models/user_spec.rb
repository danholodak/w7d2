require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it {should validate_length_of(:password).is_at_least(6).allow_nil }

  let(:guy) {User.new}

  describe "#is_password" do
    it "checks if the password matches the current user's" do
      guy.password='password'
      expect(guy.is_password?('password')).to be true
    end
  end

  describe "#reset_session_token" do
    it "changes the session token" do
      guy.email = "an email"
      guy.password = "a password"
      token = guy.session_token
      guy.reset_session_token!
      new_token = guy.session_token
      expect(new_token).not_to eq(token)
    end

    it "can't reset session token on a user without email" do
      token = guy.session_token
      expect {guy.reset_session_token!}.to raise_error("Validation failed: Email can't be blank, Password digest can't be blank")
    end
  end

  describe "::find_by_credentials" do
    it "returns nil if there's no matching email" do
      user = User.find_by_credentials("non existing email", "any password")
      expect(user).to be(nil)
    end

    it "returns user if there is matching email + password" do
      guy.email = "an email"
      guy.password = "a password"
      guy.save!
      user = User.find_by_credentials(guy.email, guy.password)
      expect(user).to eq(guy)
    end

    it "returns nil for matching email but wrong password" do
      guy.email = "an email"
      guy.password = "a password"
      guy.save!
      user = User.find_by_credentials(guy.email, "oops not me")
      expect(user).to be(nil)
    end
  end
end

# def self.find_by_credentials(email, password)
#   @user = User.find_by(email: email)
#   if @user && @user.is_password?(password)
#       return @user
#   else
#       return nil
#   end
# end
