require 'bcrypt'

class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String, :unique => true, :message => "This email is already taken"
  property :password_digest, Text
  property :password_token, Text
  property :password_token_timestamp, Text

  attr_reader :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password
  validates_uniqueness_of :email

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(:email => email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end


  def generate_random_token
    self.password_token = SecureRandom.hex(32)
    self.password_token_timestamp = Time.now
    save
  end

  def email_token
    RestClient.post "https://api:key-0inst0-aye0kcgu8z64vad00gzcw3lj0"\
    "@api.mailgun.net/v2/app20511848.mailgun.org/messages",
    :from => "Excited User <me@samples.mailgun.org>",
    :to => email,
    :subject => "Hello",
    :text => "Recover your password by clicking this link: http://localhost:4567/users/reset_password/#{password_token}"
  end


  def send_password_recovery_email
    generate_random_token
    email_token
  end


end