class User < ApplicationRecord
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true

    validates :password, length: {minimum: 6}, allow_nil: true 

    before_validation :ensure_session_token

    attr_reader :password

    def self.find_by_credentials(email, password)
        @user = User.find_by(email: email)
        if @user && @user.is_password?(password)
            return @user
        else
            return nil
        end
    end

    def is_password?(pw)
        bcrypt = BCrypt::Password.new(self.password_digest)
        bcrypt.is_password?(pw)
    end

    def password=(pw)
        @pw = pw
        self.password_digest = BCrypt::Password.create(pw)

    end

    def generate_unique_session_token
        token = SecureRandom.urlsafe_base64
        while User.exists?(session_token: token)
            token = SecureRandom.urlsafe_base64
        end
        self.session_token = token
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        return self.session_token
    end


end
