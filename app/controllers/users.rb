require 'securerandom'

get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
  @user = User.new(:email => params[:email],
                   :password => params[:password],
                   :password_confirmation => params[:password_confirmation]
                  )
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/users/forgotten_pwd' do
  erb :"users/forgotten_pwd"
end


post '/users/forgotten_pwd' do
  generate_random_token_for(params[:email])
  send_email_to_user(params[:email], @token)
   # with a link to their token url eg /users/reset_password/t8t8134r1ddad7f8hrwhfkjasd
  flash[:notice] = "Your password has been sent to your email"
  erb :"users/forgotten_pwd"
end


get '/users/reset_password/:token' do |token|
    user = User.first(:password_token => token)
    session[:token] = token
  erb :"users/reset_password"
end

post '/users/reset_password' do
  user = User.first(:password_token => session[:token])
  #reset their password
  user.update(:password => params[:password],
              :password_confirmation => params[:password_confirmation] )
  flash[:notice] = "Thank you, your password has been reset"
  redirect to("/")
  # redirect to('/sessions/new')

end


def generate_random_token_for(email)
  user = User.first(:email => email)
  @token = SecureRandom.hex(32)
  user.password_token = @token
  user.password_token_timestamp = Time.now
  user.save
end

def send_email_to_user(email, token)
  end

