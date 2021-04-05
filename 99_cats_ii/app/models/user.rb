# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

    validates :username, :session_token, presence: true, uniqueness: true 
    validates :password_digest, presence: true 

    after_initialize :ensure_session_token

    has_many(
    :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat
  )

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)

        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def reset_session_token!

        self.session_token = SecureRandom::urlsafe_base64 

        self.save!
        self.session_token 
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password 

    end

    def is_password?(password)
        password_object = BCrypt::Password.new(self.password_digest)
        password_object.is_password?(password)
    end

    


end
